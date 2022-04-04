{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
}:

buildPythonPackage rec {
  pname = "safeio";
  version = "1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = pname;
    rev = "v${version}";
    sha256 = "koun/XMsXKWNEumR6lrso8u9FInRct8fPUt+2fX2Bvg=";
  };

  patches = [
    # Adds setup.py and support files. Will be included in the next release
    (fetchpatch {
      url = "https://github.com/Animenosekai/safeIO/commit/36169fd16e316feb3d3f23c52881d3cadb331241.patch";
      sha256 = "0pk61dv3h79cld0xaial57q56ccl294xcikqwnkr3cqg1646jk4r";
    })
  ];

  # Module has no tests
  doCheck = false;
  pythonImportsCheck = [ "safeIO" ];

  meta = with lib; {
    description = "Safely write to files in Python even from multiple threads";
    homepage = "https://github.com/Animenosekai/safeio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
  };
}
