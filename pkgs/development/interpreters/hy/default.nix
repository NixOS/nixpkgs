{ stdenv, fetchurl, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "hy-${version}";
  version = "0.16.0";

  src = fetchurl {
    url = "mirror://pypi/h/hy/${name}.tar.gz";
    sha256 = "00lq38ppikrpyw38fn5iy9iwrsamsv22507cp146dsjbzkwjpzrd";
  };

  patches = [
    (fetchpatch {
      name = "bytecode-error-handling.patch";
      url = "https://github.com/hylang/hy/commit/57326785b97b7b0a89f6258fe3d04dccdc06cfc0.patch";
      sha256 = "1lxxs7mxbh0kaaa25b1pbqs9d8asyjnlf2n86qg8hzsv32jfcq92";
      excludes = [ "AUTHORS" "NEWS.rst" ];
    })
  ];

  propagatedBuildInputs = with pythonPackages; [
    appdirs
    astor
    clint
    fastentrypoints
    funcparserlib
    rply
  ];

  meta = {
    description = "A LISP dialect embedded in Python";
    homepage = http://hylang.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}
