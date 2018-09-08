{ stdenv, buildPythonPackage, fetchPypi, unidecode, regex, python }:

buildPythonPackage rec {
  pname = "awesome-slugify";
  version = "1.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wgxrhr8s5vk2xmcz9s1z1aml4ppawmhkbggl9rp94c747xc7pmv";
  };

  prePatch = ''
    substituteInPlace setup.py \
        --replace 'Unidecode>=0.04.14,<0.05' 'Unidecode>=0.04.14'
  '';

  patches = [
    ./slugify_filename_test.patch # fixes broken test by new unidecode
  ];

  propagatedBuildInputs = [ unidecode regex ];

  checkPhase = ''
      ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/dimka665/awesome-slugify;
    description = "Python flexible slugify function";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
