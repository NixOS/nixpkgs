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
  version = "0.33.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "37c3b35c2151647b968b2af24481112b2f813c30f695366db0639d529190a143";
  };

  propagatedBuildInputs = [ cloudpickle ]
    ++ lib.optional stdenv.isLinux pyinotify
    ++ lib.optional stdenv.isDarwin macfsevents;

  # hangs on darwin
  doCheck = !stdenv.isDarwin;

  checkInputs = [ mock pytestCheckHook ];

  disabledTests = [
    # depends on doit-py, which has a circular dependency on doit
    "test___main__.py"
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
