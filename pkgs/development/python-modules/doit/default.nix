{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, importlib-metadata
, isPy3k
, mock
, pytestCheckHook
, cloudpickle
, pyinotify
, macfsevents
, toml
, doit-py
, pyflakes
, configclass
, mergedict
}:

let doit = buildPythonPackage rec {
  pname = "doit";
  version = "0.36.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cdB8zJUUyyL+WdmJmVd2ZeqrV+FvZE0EM2rgtLriNLw=";
  };

  propagatedBuildInputs = [
    cloudpickle
    importlib-metadata
    toml
  ] ++ lib.optional stdenv.isLinux pyinotify
    ++ lib.optional stdenv.isDarwin macfsevents;

  nativeCheckInputs = [
    configclass
    doit-py
    mergedict
    mock
    pyflakes
    pytestCheckHook
  ];

  # escape infinite recursion with doit-py
  doCheck = false;

  passthru.tests = {
    # hangs on darwin
    check = doit.overridePythonAttrs (_: { doCheck = !stdenv.isDarwin; });
  };

  pythonImportsCheck = [ "doit" ];

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

}; in doit
