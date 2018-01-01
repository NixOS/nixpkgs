{ stdenv, buildPythonPackage, fetchPypi, python, astroid, isort,
  pytest, pytestrunner,  mccabe, configparser, backports_functools_lru_cache }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pylint";
  version = "1.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd20d6f17e7ea9d3a3a35c5d56ba2c50fdfdb7192096a1095f1791d072bc59a1";
  };

  buildInputs = [ pytest pytestrunner mccabe configparser backports_functools_lru_cache ];

  propagatedBuildInputs = [ astroid configparser isort ];

  postPatch = ''
    # Remove broken darwin tests
    sed -i -e '/test_parallel_execution/,+2d' pylint/test/test_self.py
    sed -i -e '/test_py3k_jobs_option/,+4d' pylint/test/test_self.py
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    cd pylint/test
    ${python.interpreter} -m unittest discover -p "*test*"
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.logilab.org/project/pylint;
    description = "A bug and style checker for Python";
    platforms = platforms.all;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ nand0p ];
  };
}
