{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  pkgs,
  awkward,
  numpy,
  pybind11,
  python,
  setuptools,
  setuptools-scm,
  vector,
}:

let
  fastjet =
    (pkgs.fastjet.override {
      inherit python;
      withPython = true;
    }).overrideAttrs
      (prev: {
        postInstall = (prev.postInstall or "") + ''
          mv "$out/${python.sitePackages}/"{fastjet.py,_fastjet_swig.py}
        '';
      });
  fastjet-contrib = pkgs.fastjet-contrib.override {
    inherit fastjet;
  };
in

buildPythonPackage rec {
  pname = "fastjet";
  version = "3.5.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "fastjet";
    inherit version;
    hash = "sha256-2GG9A+/2rgYpsJo1tu3BprOM7bKwYVV6/qIIMtYSr9o=";
  };

  # unvendor fastjet/fastjet-contrib
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'cmdclass={"build_ext": FastJetBuild, "install": FastJetInstall},' "" \
      --replace-fail 'str(OUTPUT / "include")' "" \
      --replace-fail 'str(OUTPUT / "lib")' ""
    for file in src/fastjet/*.py; do
      substituteInPlace "$file" \
        --replace-warn "fastjet._swig" "_fastjet_swig"
    done
    sed -i src/fastjet/_pyjet.py -e '1iimport _fastjet_swig'
  '';

  strictDeps = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    awkward
    fastjet
    numpy
    vector
  ];

  buildInputs = [
    pybind11
    fastjet-contrib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = {
    description = "Jet-finding in the Scikit-HEP ecosystem";
    homepage = "https://github.com/scikit-hep/fastjet";
    changelog = "https://github.com/scikit-hep/fastjet/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
