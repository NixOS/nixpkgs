{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.0.5327";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r7nj2hf51c954ihfxyhpbz1sd9lrc6i9zfkz11s22wpggvp06mz";
  };

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "archinfo" ];

  meta = with lib; {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = with licenses; [ bsd2 ];
    maintainers = [ maintainers.fab ];
  };
}
