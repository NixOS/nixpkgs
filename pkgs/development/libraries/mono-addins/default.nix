{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, mono4, gtk-sharp-2_0 }:

stdenv.mkDerivation rec {
  pname = "mono-addins";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "mono-addins";

    rev = "mono-addins-${version}";
    sha256 = "018g3bd8afjc39h22h2j5r6ldsdn08ynx7wg889gdvnxg3hrxgl2";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  # Use msbuild when https://github.com/NixOS/nixpkgs/pull/43680 is merged
  buildInputs = [ mono4 gtk-sharp-2_0 ];

  dontStrip = true;

  meta = with lib; {
    homepage = "https://www.mono-project.com/archived/monoaddins/";
    description = "A generic framework for creating extensible applications";
    mainProgram = "mautil";
    longDescription = ''
      Mono.Addins is a generic framework for creating extensible applications,
      and for creating libraries which extend those applications.
    '';
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
