{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, mono, gtk-sharp-2_0 }:

stdenv.mkDerivation rec {
  name = "mono-addins-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "mono-addins";

    rev = "mono-addins-${version}";
    sha256 = "1hnn0a2qsjcjprsxas424bzvhsdwy0yc2jj5xbp698c0m9kfk24y";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ mono gtk-sharp-2_0 ];

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = http://www.mono-project.com/archived/monoaddins/;
    description = "A generic framework for creating extensible applications";
    longDescription = ''
      Mono.Addins is a generic framework for creating extensible applications,
      and for creating libraries which extend those applications.
    '';
    platforms = platforms.linux;
  };
}
