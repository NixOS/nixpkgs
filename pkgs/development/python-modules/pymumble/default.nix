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
  version = "1.7";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "azlux";
    repo = "pymumble";
    rev = "refs/tags/${version}";
    sha256 = "sha256-NMp1yZ+R9vmne7old7z9UvcxSi6C044g68ZQsofT0gA=";
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
