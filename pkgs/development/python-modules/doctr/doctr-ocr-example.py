# Based on example from https://github.com/mindee/doctr/tree/v0.7.0#reading-files
import argparse
import importlib

from pathlib import Path

from doctr.io import DocumentFile
from doctr.models import ocr_predictor


# Monkey-patch doctr so that it loads model files from a local dir
# instead of downloading them from the Internet.
def patch_doctr_download(real_cache_dir) -> None:
    def safe_download_from_url(
        url: str,
        file_name = None,
        hash_prefix = None, # ignored
        cache_dir = None, # ignored
        cache_subdir = None,
    ):
        if not isinstance(file_name, str):
            file_name = url.rpartition('/')[-1]

        folder_path = real_cache_dir if cache_subdir is None else real_cache_dir / cache_subdir
        file_path = folder_path.joinpath(file_name)

        if not file_path.is_file():
            raise RuntimeError(f"Tried to load model from {file_path} but it doesn't exist.")

        print(f"Loading model from {file_path}")
        return file_path

    importlib.import_module("doctr.models.utils.pytorch").download_from_url = safe_download_from_url


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--offline-models-dir", dest="offline_models_dir", type=Path, required=True)
    parser.add_argument("--input-file", dest="input_file", type=Path, required=True)
    args = parser.parse_args()

    patch_doctr_download(args.offline_models_dir)

    model = ocr_predictor(
        pretrained=True,
        det_arch="db_resnet50_rotation",
        reco_arch="crnn_vgg16_bn",
    )
    if args.input_file.name.lower().endswith(".pdf"):
        doc = DocumentFile.from_pdf(args.input_file)
    else:
        doc = DocumentFile.from_images(args.input_file)
    result = model(doc)
    print(result.export())  # print as JSON

if __name__ == "__main__":
    main()
