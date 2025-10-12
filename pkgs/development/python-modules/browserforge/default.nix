{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  setuptools,
  wheel,
  pysocks,
  pyyaml,
  tqdm,
  orjson,
  ua-parser,
  poetry-core,
}:

# Create a patched version of browserforge
buildPythonPackage rec {
  pname = "browserforge";
  version = "1.2.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1b7G3/1HSLMPusn5we8zsmwBojGFJAv5ABGEPhdLfsw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    poetry-core
  ];

  propagatedBuildInputs = [
    pysocks
    pyyaml
    tqdm
    ua-parser
    click
    orjson
  ];

  # Patch the package to use platformdirs for storing data files
  postPatch = ''
    # Add platformdirs to imports
    substituteInPlace browserforge/bayesian_network.py \
      --replace "import zipfile" "import zipfile\nimport platformdirs\nimport os"

    # Patch the file path logic to use user's cache directory
    substituteInPlace browserforge/bayesian_network.py \
      --replace "def extract_json(path):" \
      "def extract_json(path):\n    # If the path is in the Nix store, redirect to user cache\n    if str(path).startswith('/nix/store'):\n        cache_dir = platformdirs.user_cache_dir('browserforge')\n        os.makedirs(cache_dir, exist_ok=True)\n        filename = os.path.basename(path)\n        new_path = os.path.join(cache_dir, filename)\n        # If the file doesn't exist in cache, we need to create it\n        if not os.path.exists(new_path):\n            # This means we couldn't download it, create an empty zip file\n            with zipfile.ZipFile(new_path, 'w') as _:\n                pass\n        path = new_path\n"

    # Patch the download method to use user's cache directory
    substituteInPlace browserforge/headers/generator.py \
      --replace "DATA_DIR = Path(__file__).parent / 'data'" \
      "import platformdirs\nimport os\n\n# Use user cache directory instead of package directory\nDATA_DIR = Path(platformdirs.user_cache_dir('browserforge', 'browserforge'))\nos.makedirs(DATA_DIR, exist_ok=True)"
  '';

  meta = {
    description = "Intelligent browser header & fingerprint generator";
    homepage = "https://github.com/daijro/browserforge";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      monk3yd
    ];
  };

}
