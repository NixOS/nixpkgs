{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, packaging
, setuptools
, pkgconfig
, freetype
, pytest
, python
, pillow
, numpy
}:

buildPythonPackage rec {
  pname = "aggdraw";
  version = "1.3.16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytroll";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2yajhuRyQ7BqghbSgPClW3inpw4TW2DhgQbomcRFx94=";
  };

  patches = [
    # Removes `register` storage class specifier, which is not allowed in C++17.
    (fetchpatch {
      url = "https://github.com/pytroll/aggdraw/commit/157ed49803567e8c3eeb7dfeff4c116db35747f7.patch";
      hash = "sha256-QSzpO90u5oSBWUzehRFbXgZ1ApEfLlfp11MUx6w11aI=";
    })
    # Use non-deprecated Unicode APIs, which is needed for compatibility with Python 3.12.
    (fetchpatch {
      url = "https://github.com/pytroll/aggdraw/commit/367075ccdc65a0da1efb4032c2ee008d7bee915b.patch";
      hash = "sha256-sPH7X1b5h7GJVleTytqBW59aY2mY0a/4yF2+2YgzKTg=";
    })
  ];

  nativeBuildInputs = [
    packaging
    setuptools
    pkgconfig
  ];

  buildInputs = [
    freetype
  ];

  nativeCheckInputs = [
    numpy
    pillow
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} selftest.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "aggdraw" ];

  meta = with lib; {
    description = "High quality drawing interface for PIL";
    homepage = "https://github.com/pytroll/aggdraw";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
