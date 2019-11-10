{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numpy
, six
, ruamel_yaml
, msgpack
, coverage
, coveralls
, pymongo
, lsof
}:

buildPythonPackage rec {
  pname = "monty";
  version = "1.0.4";

  # No tests in Pypi
  src = fetchFromGitHub {
    owner = "materialsvirtuallab";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vqaaz0dw0ypl6sfwbycpb0qs3ap04c4ghbggklxih66spdlggh6";
  };

  checkInputs = [ lsof nose numpy msgpack coverage coveralls pymongo];
  propagatedBuildInputs = [ six ruamel_yaml ];

  preCheck = ''
    substituteInPlace tests/test_os.py \
      --replace 'self.assertEqual("/usr/bin/find", which("/usr/bin/find"))' '#'
  '';

  meta = with lib; {
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
