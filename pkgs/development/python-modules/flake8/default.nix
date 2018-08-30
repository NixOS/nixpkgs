{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, fetchpatch
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7253265f7abd8b313e3892944044a365e3f4ac3fcdcfb4298f55ee9ddf188ba0";
  };

  # Allow newer version of pycodestyle and pyflakes
  patches = [
    (fetchpatch {
      url = https://gitlab.com/pycqa/flake8/commit/4fcbcccf381ce0987faa297173e4008b0490918f.patch;
      sha256 = "0lfsg9n92fc8whj29paqsx7ifap2szv7pxj13hy739y87gsps676";
      excludes = [ "setup.cfg" ];
    })
    (fetchpatch {
      url = https://gitlab.com/pycqa/flake8/commit/0273ca561f0ad03adff41ce5d95a1ec31b10fe5a.patch;
      sha256 = "1ziy54v1cm7gn7a551qvrl0rs16q8zpzh303xf5gn4rxxz13qnzb";
      excludes = [ "setup.cfg" ];
    })
    (fetchpatch {
      url = https://gitlab.com/pycqa/flake8/commit/85c503de32f81ed9859d902cbe20eb4d2e4e8d55.patch;
      sha256 = "0170hjaxkq5ssva9rwkcgm4whb07fnxdb0z12gzmvw5w53hkqxj4";
    })
    (fetchpatch {
      url = https://gitlab.com/pycqa/flake8/commit/68782675b7f00c5d24c24e424efd1fbcb0705224.patch;
      sha256 = "183lcw7aqv5yzm8pfisrfngq3fchc7h3j7254c5hy2hqq653v98s";
    })
    (fetchpatch {
      url = https://gitlab.com/pycqa/flake8/commit/ef1d5ceefcbfacf5dfe94534c4879ca814b130f0.patch;
      sha256 = "1j5f0l4xryfhirixwjcl1lzayjhy6vhkizkpm7w87piylim8y26y";
    })
    (fetchpatch {
      url = https://gitlab.com/pycqa/flake8/commit/527af5c214ef0eccfde3dd58d7ea15e09c483bd3.patch;
      sha256 = "1y51r78770z27d43v64lrg8zvm39ycszzhh15cx8wq8wp3b7iz5x";
      excludes = [ "setup.cfg" ];
    })
  ];

  buildInputs = [ pytest mock pytestrunner ];
  propagatedBuildInputs = [ pyflakes pycodestyle mccabe ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ]
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ configparser ];

  meta = with stdenv.lib; {
    description = "Code checking using pep8 and pyflakes";
    homepage = https://pypi.python.org/pypi/flake8;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
