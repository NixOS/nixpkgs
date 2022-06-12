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
, toml
}:

buildPythonPackage rec {
  pname = "doit";
  version = "0.35.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cVoyLIdMTLhiOU46DWn/MlcrUln1cDb7/cEFPEwB00g=";
  };

  propagatedBuildInputs = [
    cloudpickle
    toml
  ] ++ lib.optional stdenv.isLinux pyinotify
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
