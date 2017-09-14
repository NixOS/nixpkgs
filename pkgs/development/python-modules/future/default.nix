{ lib
, buildPythonPackage
, fetchPypi
, isPy26
, importlib
, argparse
}:

buildPythonPackage rec {
  pname = "future";
  version = "0.16.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nzy1k4m9966sikp0qka7lirh8sqrsyainyf8rk97db7nwdfv773";
  };

  propagatedBuildInputs = lib.optionals isPy26 [ importlib argparse ];
  doCheck = false;

  meta = {
    description = "Clean single-source support for Python 3 and 2";
    longDescription = ''
      python-future is the missing compatibility layer between Python 2 and
      Python 3. It allows you to use a single, clean Python 3.x-compatible
      codebase to support both Python 2 and Python 3 with minimal overhead.

      It provides future and past packages with backports and forward ports
      of features from Python 3 and 2. It also comes with futurize and
      pasteurize, customized 2to3-based scripts that helps you to convert
      either Py2 or Py3 code easily to support both Python 2 and 3 in a
      single clean Py3-style codebase, module by module.
    '';
    homepage = https://python-future.org;
    downloadPage = https://github.com/PythonCharmers/python-future/releases;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prikhi ];
  };
}
