{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  cython,
  gmp,
  pari,
  perl,
}:

buildPythonPackage rec {
  pname = "cypari";
  version = "2.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "CyPari";
    tag = "${version}_as_released";
    hash = "sha256-RJ9O1KsDHmMkTCIFUrcSUkA5ijTsxmoI939QCsCib0Y=";
  };

  patches = [
    (fetchpatch {
      name = "support-aarch64-linux.patch";
      url = "https://github.com/3-manifolds/CyPari/commit/6197171b52ee4f44a4954ddd0e2e36769b189dee.patch";
      hash = "sha256-j2P7DEGD2B8q9Hh4G2mQng76fQdUpeAdFYoTD7Ui/Dk=";
    })
    (fetchpatch {
      name = "fix-build-with-cython-3_1.patch";
      url = "https://github.com/3-manifolds/CyPari/compare/622e112ffcf0383e2110954ff3ac3c42c006ebe1...50bcbd2b39177f5e4c5a3551a8a14f75ab05a5d6.patch";
      hash = "sha256-6ayvtHMS3YtzzklHaaLzl9d4zHJhm0lVZQZFS9ykFY4=";
    })
  ];

  preBuild = ''
    mkdir libcache
    ln -s ${gmp} libcache/gmp
    ln -s ${pari} libcache/pari
  '';

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    perl
  ];

  pythonImportsCheck = [ "cypari" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -P -m cypari.test
    runHook postCheck
  '';

  meta = {
    description = "Sage's PARI extension, modified to stand alone";
    homepage = "https://github.com/3-manifolds/CyPari";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
    changelog = "https://github.com/3-manifolds/CyPari/releases/tag/${src.tag}";
  };
}
