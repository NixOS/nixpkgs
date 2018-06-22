{ stdenv, buildPythonPackage, fetchFromGitHub, nose, numpy, six, ruamel_yaml, msgpack-python, coverage, coveralls, pymongo, lsof }:

buildPythonPackage rec {
  pname = "monty";
  version = "1.0.2";

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "materialsvirtuallab";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ss70fanavqdpj56yymj06lacgnknb4ap39m2q28v9lz32cs6xdg";
  };

  propagatedBuildInputs = [ nose numpy six ruamel_yaml msgpack-python coverage coveralls pymongo lsof ];
  
  preCheck = ''
    substituteInPlace tests/test_os.py \
      --replace 'def test_which(self):' '#' \
      --replace 'py = which("python")' '#' \
      --replace 'self.assertEqual(os.path.basename(py), "python")' '#' \
      --replace 'self.assertEqual("/usr/bin/find", which("/usr/bin/find"))' '#' \
      --replace 'self.assertIs(which("non_existent_exe"), None)' '#' \
  '';

  meta = with stdenv.lib; {
    description = "Serves as a complement to the Python standard library by providing a suite of tools to solve many common problems";
    longDescription = "
      Monty implements supplementary useful functions for Python that are not part of the 
      standard library. Examples include useful utilities like transparent support for zipped files, useful design 
      patterns such as singleton and cached_class, and many more.
    ";
    homepage = https://github.com/materialsvirtuallab/monty;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

