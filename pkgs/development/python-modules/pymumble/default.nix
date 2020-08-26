{ buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  lib,
  opuslib,
  protobuf,
}:

buildPythonPackage rec {
  pname = "pymumble";
  version = "0.3.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "azlux";
    repo = "pymumble";
    rev = "1dd6d6d4df2fdef33202f17e2acf3ba9678a5737";
    sha256 = "1r1sch8xrpbzffsb72lhp5xjr3ac3xb599n44vsfmaam3xklz6vz";
  };

  propagatedBuildInputs = [ opuslib protobuf ];

  pythonImportsCheck = [ "pymumble_py3" ];

  meta = with lib; {
    description = "Python 3 version of pymumble, Mumble library used for multiple uses like making mumble bot.";
    homepage = "https://github.com/azlux/pymumble";
    license = licenses.gpl3;
    maintainers = with maintainers; [ thelegy ];
  };
}
