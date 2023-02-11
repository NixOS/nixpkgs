{ buildPythonPackage
, fetchFromGitHub
, isPy27
, lib
, opuslib
, protobuf
, pytestCheckHook
, pycrypto
}:

buildPythonPackage rec {
  pname = "pymumble";
  version = "1.6.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "azlux";
    repo = "pymumble";
    rev = version;
    sha256 = "1qbsd2zvwd9ksclgiyrl1z79ms0zximm4527mnmhvq36lykgki7s";
  };

  postPatch = ''
    # Changes all `library==x.y.z` statements to just `library`
    # So that we aren't constrained to a specific version
    sed -i 's/\(.*\)==.*/\1/' requirements.txt
  '';

  propagatedBuildInputs = [
    opuslib
    protobuf
  ];

  nativeCheckInputs = [
    pycrypto
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymumble_py3"
    "pymumble_py3.constants"
  ];

  meta = with lib; {
    description = "Python 3 version of pymumble, Mumble library used for multiple uses like making mumble bot.";
    homepage = "https://github.com/azlux/pymumble";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thelegy infinisil ];
  };
}
