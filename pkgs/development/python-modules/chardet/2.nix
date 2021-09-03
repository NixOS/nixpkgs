{ lib, buildPythonPackage, fetchPypi, fetchpatch
, pytest, pytest-runner, hypothesis }:

buildPythonPackage rec {
  pname = "chardet";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bpalpia6r5x1kknbk11p1fzph56fmmnp405ds8icksd3knr5aw4";
  };

  patches = [
    # Add pytest 4 support. See: https://github.com/chardet/chardet/pull/174
    (fetchpatch {
      url = "https://github.com/chardet/chardet/commit/0561ddcedcd12ea1f98b7ddedb93686ed8a5ffa4.patch";
      sha256 = "1y1xhjf32rdhq9sfz58pghwv794f3w2f2qcn8p6hp4pc8jsdrn2q";
    })
  ];

  checkInputs = [ pytest pytest-runner hypothesis ];

  meta = with lib; {
    homepage = "https://github.com/chardet/chardet";
    description = "Universal encoding detector";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
