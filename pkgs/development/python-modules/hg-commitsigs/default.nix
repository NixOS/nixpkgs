{
  lib,
  fetchhg,
  stdenv,
  python,
}:

stdenv.mkDerivation rec {
  pname = "hg-commitsigs";
  # Latest tag is 11 years old.
  version = "unstable-2021-01-08";

  src = fetchhg {
    url = "https://foss.heptapod.net/mercurial/commitsigs";
    rev = "b53eb6862bff";
    sha256 = "sha256-PS1OhC9MiVFD7WYlIn6FavD5TyhM50WoV6YagI2pLxU=";
  };

  # Not sure how the tests are supposed to be run, and they 10 years old...
  doCheck = false;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/${python.sitePackages}/hgext3rd/
    install -D $src/commitsigs.py \
               $out/${python.sitePackages}/hgext3rd/
  '';

  meta = with lib; {
    description = "Automatic signing of changeset hashes";
    longDescription = ''
      This packages provides a Mercurial extension that lets you sign
      the changeset hash when you commit.  The signature is embedded
      directly in the changeset itself; there wont be any extra
      commits.  Either GnuPG or OpenSSL can be used to sign the hashes.
    '';
    homepage = "https://foss.heptapod.net/mercurial/commitsigs";
    maintainers = with maintainers; [ yoctocell ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix; # same as Mercurial
  };
}
