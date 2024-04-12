{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, fetchurl, fetchgit, git, glibc, python3Packages }:

let
  mplcursors = buildPythonPackage rec {
    pname = "mplcursors";
    version = "0.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-DjLBxhP4g6Q21TrWWMA3er2ErAI12UDBNeEclKG679A";
    };

    # Build-time dependencies
    nativeBuildInputs = [ python3Packages.setuptools_scm ];

    # Run-time dependencies
    propagatedBuildInputs = [
      python3Packages.matplotlib
      python3Packages.pytest
      python3Packages.weasyprint
    ] ++ lib.optional (python3Packages.pythonOlder "3.8") python3Packages.importlib-metadata;

    meta = with lib; {
      description = "Interactive cursors for Matplotlib";
      homepage = "https://example.com/mplcursors";
      license = licenses.mit;
    };
  };

  ctypesgen = buildPythonPackage rec {
    pname = "ctypesgen";
    version = "pypdfium2";

    src = fetchFromGitHub {
      owner = "pypdfium2-team";
      repo = "ctypesgen";
      rev = "pypdfium2";
      sha256 = "sha256-klc6mouJ8w/xIgx8xmDXrui5Ebyicg++KIgr+b5ozbk=";
    };

    # Specify native build inputs
    nativeBuildInputs = with python3Packages; [
      setuptools
      wheel
      setuptools_scm
      tomli
    ];

    buildInputs = [ glibc ];

    # Custom patching steps
    postPatch = ''
      export SETUPTOOLS_SCM_PRETEND_VERSION=1.0.0 # fake version
      mkdir -p dist
    '';

    # Disable checks if necessary
    doCheck = false;

    # Run-time dependencies
    propagatedBuildInputs = [ python3Packages.wheel python3Packages.toml ];

    meta = with lib; {
      description = "Python bindings generator for C libraries";
      homepage = "https://github.com/pypdfium2-team/ctypesgen";
      license = licenses.mit;
    };
  };

  pypdfium2 = buildPythonPackage rec {
    pname = "pypdfium2";
    version = "4.24.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-YnBsBrxb45qnolMa+AJCBCm2xMR0mO69JSGvfpiNCEg=";
    };

    # Additional source and binary fetching
    headers = fetchurl {
      url = "https://pdfium.googlesource.com/pdfium/+archive/7233e99fcaeb18adbf048be2df0b1cca355abc70/public.tar.gz";
      sha256 = "sha256-920OK/8UXrwwlf+FBrIKdTl3Q35W1li/BEpGknbtRlU=";
    };

    binaries = fetchurl {
      url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium%2F6124/pdfium-linux-x64.tgz";
      sha256 = "sha256-nFIwGgpwFV31rgu6ZFZtrcAAEltBNPgoVy5hR7evbA8=";
    };

    # Patches and post-patch steps
    patches = [ ./pypdfdfium2-get-binaries.patch ];

    # Place headers and binary downloads in the expected locations
    postPatch = ''
      mkdir -p data/bindings/headers
      tar -xzf ${headers} -C data/bindings/headers
      mkdir -p data/linux_x64
      cp ${binaries} data/linux_x64/pdfium-linux-x64.tgz
      cp ${binaries} pdfium-linux-x64.tgz
    '';

    # Fetching pdfium binaries
    pdfium-binaries = fetchgit {
      url = "https://github.com/bblanchon/pdfium-binaries.git";
      rev = "chromium/6124";
      sha256 = "sha256-2GfuqI95RLLhSC13Qc97wK/XrAqPxnDNfiFD2hNK4+A=";
    };

    # Native build inputs
    nativeBuildInputs = [ git ctypesgen ];

    meta = with lib; {
      description = "Python bindings for the PDFium library";
      homepage = "https://example.com/pypdfium2";
      license = licenses.mit;
    };
  };

  python-doctr = buildPythonPackage rec {
    pname = "python-doctr";
    version = "0.7.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-4F7yC8WPxiyA0vOWjtOADLFXf8k1OkZTw6eyw+D2SFU=";
    };

    # Build-time dependencies
    nativeBuildInputs = [ python3Packages.pip ];

    # Run-time dependencies
    propagatedBuildInputs = [
      python3Packages.opencv4
      python3Packages.setuptools
      python3Packages.huggingface-hub
      python3Packages.unidecode
      python3Packages.rapidfuzz
      python3Packages.langdetect
      python3Packages.shapely
      python3Packages.pyclipper
      python3Packages.scipy
      python3Packages.h5py
      mplcursors
      pypdfium2
    ];

    # Disable checks if necessary
    doCheck = false;

    meta = with lib; {
      description = "A powerful tool for Python documentation";
      homepage = "https://example.com/python-doctr";
      license = licenses.mit;
    };
  };

  # Override for python-doctr with additional dependencies for pyTorch
  python-doctr-pytorch = python3Packages.toPythonModule (python-doctr.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
      python3Packages.torch
      python3Packages.torchvision
    ];
  }));

in
{
  packages = {
    python-doctr = python-doctr;
    python-doctr-pytorch = python-doctr-pytorch;
  };

  defaultPackage.x86_64-linux = python-doctr;
}
