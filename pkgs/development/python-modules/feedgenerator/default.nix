{ stdenv, buildPythonPackage, glibcLocales, fetchurl, six, pytz }:

buildPythonPackage rec {
  pname = "feedgenerator";
  version = "1.9";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/f/feedgenerator/${name}.tar.gz";
    sha256 = "01mirwkm7xfx539hmvj7g9da1j51gw5lsx74dr0glizskjm5vq2s";
  };

  buildInputs = [ glibcLocales ];

  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ six pytz ];

  meta = with stdenv.lib; {
    description = "Standalone version of django.utils.feedgenerator, compatible with Py3k";
    homepage = https://github.com/dmdm/feedgenerator-py3k.git;
    maintainers = with maintainers; [ garbas ];
  };
}
