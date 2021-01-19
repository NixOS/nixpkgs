{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, isPy3k
, mock
, pytestCheckHook
, cloudpickle
, pyinotify
, macfsevents
}:

buildPythonPackage rec {
  pname = "doit";
  version = "0.32.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "033m6y9763l81kgqd07rm62bngv3dsm3k9p28nwsn2qawl8h8g9j";
  };

  propagatedBuildInputs = [ cloudpickle ]
    ++ lib.optional stdenv.isLinux pyinotify
    ++ lib.optional stdenv.isDarwin macfsevents;

  checkInputs = [ mock pytestCheckHook ];

  disabledTests = [
    # depends on doit-py, which has a circular dependency on doit
    "test___main__.py"
    # https://github.com/pydoit/doit/issues/341
    "test_not_picklable_raises_InvalidTask"
  ];

  meta = with lib; {
    homepage = "https://pydoit.org/";
    description = "A task management & automation tool";
    license = licenses.mit;
    longDescription = ''
      doit is a modern open-source build-tool written in python
      designed to be simple to use and flexible to deal with complex
      work-flows. It is specially suitable for building and managing
      custom work-flows where there is no out-of-the-box solution
      available.
    '';
    maintainers = with maintainers; [ pSub ];
  };
}
