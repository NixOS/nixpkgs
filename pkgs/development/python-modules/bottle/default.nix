{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, setuptools }:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0819b74b145a7def225c0e83b16a4d5711fde751cd92bae467a69efce720f69e";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-28473.patch";
      url = "https://github.com/bottlepy/bottle/commit/57a2f22e0c1d2b328c4f54bf75741d74f47f1a6b.patch";
      sha256 = "0jgvpmsq5zswr077ql5h4kmglqh7z1hf0w5gr8x59am0sgjcz21v";
    })
  ];

  propagatedBuildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    homepage = "http://bottlepy.org";
    description = "A fast and simple micro-framework for small web-applications";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ koral ];
  };
}
