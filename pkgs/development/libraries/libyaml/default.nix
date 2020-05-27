{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libyaml";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "libyaml";
    rev = version;
    sha256 = "04z25mvw86jhzyrj0h8mlgisvj9glc5ww9g0cymzjfsd7z33gnmy";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = "https://pyyaml.org/";
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
