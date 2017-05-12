{ stdenv, fetchzip, buildPythonPackage, isPy3k, execnet, pytest, setuptools_scm }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-xdist";
  version = "1.14";

  src = fetchzip {
    url = "mirror://pypi/p/pytest-xdist/${name}.zip";
    sha256 = "18j6jq4r47cbbgnci0bbp0kjr9w12hzw7fh4dmsbm072jmv8c0gx";
  };

  buildInputs = [ pytest setuptools_scm ];
  propagatedBuildInputs = [ execnet ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    rm testing/acceptance_test.py testing/test_remote.py testing/test_slavemanage.py
  '';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = https://github.com/pytest-dev/pytest-xdist;
    license = licenses.mit;
  };
}
