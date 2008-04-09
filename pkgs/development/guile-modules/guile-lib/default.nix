{stdenv, fetchurl, guile, texinfo}:

stdenv.mkDerivation rec {
  name = "guile-lib-0.1.6";
  src = fetchurl {
    url = "http://download.gna.org/guile-lib/" + name + ".tar.gz";
    sha256 = "827744c7954078f1f37e0bf70252ec70b4d60c1482a3542a49bd09723cf65d12";
  };

  buildInputs = [guile texinfo];

  postInstall = ''
    # Remove modules already provided by Guile.
    if "${guile}/bin/guile" -c '(use-modules (srfi srfi-34))'
    then
	rm -f "$out/share/guile/site/srfi/srfi-34.scm"
    fi
    if "${guile}/bin/guile" -c '(use-modules (srfi srfi-35))'
    then
	rm -f "$out/share/guile/site/srfi/srfi-35.scm"
    fi
  '';

  doCheck = true;

  meta = {
    description = ''Guile-Library, a collection of useful Guile
                    Scheme modules'';
    homepage = http://home.gna.org/guile-lib/;
    license = "GPL";
  };
}
