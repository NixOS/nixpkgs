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
