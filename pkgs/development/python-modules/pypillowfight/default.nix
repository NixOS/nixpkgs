{ stdenv, buildPythonPackage, fetchFromGitLab, nose, pillow
, isPy3k, isPyPy
}:
buildPythonPackage rec {
  pname = "pypillowfight";
  version = "0.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "libpillowfight";
    rev = version;
    sha256 = "0wbzfhbzim61fmkm7p7f2rwslacla1x00a6xp50haawjh9zfwc4y";
  };

  prePatch = ''
    echo '#define INTERNAL_PILLOWFIGHT_VERSION "${version}"' > src/pillowfight/_version.h
  '';

  # Disable tests because they're designed to only work on Debian:
  # https://github.com/jflesch/libpillowfight/issues/2#issuecomment-268259174
  doCheck = false;

  # Python 2.x is not supported, see:
  # https://github.com/jflesch/libpillowfight/issues/1
  disabled = !isPy3k && !isPyPy;

  # This is needed by setup.py regardless of whether tests are enabled.
  buildInputs = [ nose ];
  propagatedBuildInputs = [ pillow ];

  meta = with stdenv.lib; {
    description = "Library containing various image processing algorithms";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
  };
}
