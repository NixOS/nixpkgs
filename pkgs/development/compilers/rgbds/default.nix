{stdenv, fetchFromGitHub, yacc}:

stdenv.mkDerivation rec {
  name = "rgbds-${version}";
  version = "0.2.4";
  src = fetchFromGitHub {
    owner = "bentley";
    repo = "rgbds";
    rev = "v${version}";
    sha256 = "0dwq0p9g1lci8sm12a2rfk0g33z2vr75x78zdf1g84djwbz8ipc6";
  };
  nativeBuildInputs = [ yacc ];
  installFlags = "PREFIX=\${out}";

  meta = with stdenv.lib; {
    homepage = https://www.anjbe.name/rgbds/;
    description = "An assembler/linker package that produces Game Boy programs";
    license = licenses.free;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
