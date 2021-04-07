{ buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPy27
, lib
, opuslib
, protobuf
, pytestCheckHook
, pycrypto
}:

buildPythonPackage rec {
  pname = "pymumble";
  version = "1.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "azlux";
    repo = "pymumble";
    rev = version;
    sha256 = "04nc66d554a98mbmdgzgsg6ncaz0jsn4zdr3mr14w6wnhrxpjkrs";
  };
  patches = [
    # Compatibility with pycryptodome (which is what our pycrypto really is)
    # See https://github.com/azlux/pymumble/pull/99
    (fetchpatch {
      url = "https://github.com/azlux/pymumble/pull/99/commits/b85548a0e1deaac820954b1c0b308af214311a14.patch";
      sha256 = "0w9dpc87rny6vmhi634pih1p97b67jm26qajscpa9wp6nphdlxlj";
    })
  ];

  postPatch = ''
    # Changes all `library==x.y.z` statements to just `library`
    # So that we aren't constrained to a specific version
    sed -i 's/\(.*\)==.*/\1/' requirements.txt
  '';

  propagatedBuildInputs = [ opuslib protobuf ];

  checkInputs = [ pytestCheckHook pycrypto ];

  pythonImportsCheck = [ "pymumble_py3" ];

  meta = with lib; {
    description = "Python 3 version of pymumble, Mumble library used for multiple uses like making mumble bot.";
    homepage = "https://github.com/azlux/pymumble";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thelegy infinisil ];
  };
}
