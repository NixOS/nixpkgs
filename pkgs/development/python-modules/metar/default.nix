{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "metar";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
    rev = "v${version}";
    hash = "sha256-pl2NWRfFCYyM2qvBt4Ic3wgbGkYZvAO6pX2Set8zYW8=";
  };

  patches = [
    # Fix flapping test; https://github.com/python-metar/python-metar/issues/161
    (fetchpatch {
      url = "https://github.com/python-metar/python-metar/commit/716fa76682e6c2936643d1cf62e3d302ef29aedd.patch";
      hash = "sha256-y82NN+KDryOiH+eG+2ycXCO9lqQLsah4+YpGn6lM2As=";
      name = "fix_flapping_test.patch";
    })

    # Fix circumvent a sometimes impossible test
    # https://github.com/python-metar/python-metar/issues/165
    (fetchpatch {
      url = "https://github.com/python-metar/python-metar/commit/b675f4816d15fbfc27e23ba9a40cdde8bb06a552.patch";
      hash = "sha256-v+E3Ckwxb42mpGzi2C3ka96wHvurRNODMU3xLxDoVZI=";
      name = "fix_impossible_test.patch";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "metar" ];

  meta = with lib; {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
    license = with licenses; [ bsd1 ];
    maintainers = with maintainers; [ fab ];
  };
}
