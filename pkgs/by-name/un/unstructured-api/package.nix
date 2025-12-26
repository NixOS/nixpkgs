{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  nix-update-script,
}:
let
  pythonEnv = python3.withPackages (
    packages:
    with packages;
    [
      aiofiles
      annotated-types
      antlr4-python3-runtime
      anyio
      backoff
      beautifulsoup4
      cachetools
      certifi
      cffi
      chardet
      charset-normalizer
      click
      coloredlogs
      contourpy
      cryptography
      cycler
      dataclasses-json
      deprecated
      effdet
      emoji
      et-xmlfile
      eval-type-backport
      fastapi
      filelock
      filetype
      flatbuffers
      fonttools
      fsspec
      google-api-core
      google-auth
      google-cloud-vision
      googleapis-common-protos
      grpcio
      grpcio-status
      h11
      html5lib
      httpcore
      httpx
      huggingface-hub
      humanfriendly
      idna
      iopath
      jinja2
      joblib
      jsonpath
      kiwisolver
      langdetect
      layoutparser
      lxml
      markdown
      markupsafe
      marshmallow
      matplotlib
      mpmath
      mypy-extensions
      nest-asyncio
      networkx
      nltk
      numpy
      olefile
      omegaconf
      onnx
      onnxruntime
      opencv-python
      openpyxl
      packaging
      pandas
      pdf2image
      pdfminer-six
      pdfplumber
      # pi-heif
      pikepdf
      pillow
      portalocker
      proto-plus
      protobuf
      psutil
      pyasn1
      pyasn1-modules
      pycocotools
      pycparser
      pycryptodome
      pydantic
      pydantic-core
      pypandoc
      pyparsing
      pypdf
      pypdfium2
      python-dateutil
      python-docx
      python-iso639
      python-magic
      python-multipart
      # python-oxmsg
      python-pptx
      pytz
      pyyaml
      rapidfuzz
      ratelimit
      regex
      requests
      requests-toolbelt
      rsa
      safetensors
      scipy
      six
      sniffio
      soupsieve
      starlette
      sympy
      timm
      tokenizers
      torch
      torchvision
      tqdm
      transformers
      typing-extensions
      typing-inspect
      tzdata
      unstructured
      # unstructured-client
      unstructured-inference
      # unstructured-pytesseract
      urllib3
      uvicorn
      webencodings
      wrapt
      xlrd
      xlsxwriter
    ]
    ++ google-api-core.optional-dependencies.grpc
    ++ unstructured.optional-dependencies.all-docs
  );
  version = "0.0.89";
  unstructured_api_nltk_data = python3.pkgs.nltk.dataDir (d: [
    d.punkt
    d.averaged-perceptron-tagger
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "unstructured-api";
  inherit version;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-api";
    rev = version;
    hash = "sha256-FxWOR13wZwowZny2t4Frwl+cLMv+6nkHxQm9Xc4Y9Kw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin $out/lib
    cp -r . $out/lib

    makeWrapper ${pythonEnv}/bin/uvicorn $out/bin/unstructured-api \
      --set NLTK_DATA ${unstructured_api_nltk_data} \
      --prefix PYTHONPATH : $out/lib \
      --add-flags "prepline_general.api.app:app"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source toolkit designed to make it easy to prepare unstructured data like PDFs, HTML and Word Documents for downstream data science tasks";
    homepage = "https://github.com/Unstructured-IO/unstructured-api";
    changelog = "https://github.com/Unstructured-IO/unstructured-api/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
