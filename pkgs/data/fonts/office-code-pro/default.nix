{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "office-code-pro";
  version = "1.004";

  src = fetchFromGitHub {
    owner = "nathco";
    repo = "Office-Code-Pro";
    rev = version;
    sha256 = "0znmjjyn5q83chiafy252bhsmw49r2nx2ls2cmhjp4ihidfr6cmb";
  };

  installPhase = ''
    fontDir=$out/share/fonts/opentype
    docDir=$out/share/doc/${pname}-${version}
    mkdir -p $fontDir $docDir
    install -Dm644 README.md $docDir
    install -t $fontDir -m644 'Fonts/Office Code Pro/OTF/'*.otf
    install -t $fontDir -m644 'Fonts/Office Code Pro D/OTF/'*.otf
  '';

  meta = with stdenv.lib; {
    description = "A customized version of Source Code Pro";
    longDescription = ''
      Office Code Pro is a customized version of Source Code Pro, the monospaced
      sans serif originally created by Paul D. Hunt for Adobe Systems
      Incorporated. The customizations were made specifically for text editors
      and coding environments, but are still very usable in other applications.
    '';
    homepage = https://github.com/nathco/Office-Code-Pro;
    license = licenses.ofl;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
