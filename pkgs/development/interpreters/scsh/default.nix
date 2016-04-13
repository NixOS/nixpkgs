{ stdenv, fetchgit, autoreconfHook, scheme48 }:

stdenv.mkDerivation {
  name = "scsh-0.7pre";

  src = fetchgit {
    url = "git://github.com/scheme/scsh.git";
    rev = "f99b8c5293628cfeaeb792019072e3a96841104f";
    fetchSubmodules = true;
    sha256 = "0fz1r0bmiii9ld91r84dqkqwhnqk0h6drdycq93zcy5ndyn12fqp";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ scheme48 ];
  configureFlags = ''--with-scheme48=${scheme48}'';

  meta = with stdenv.lib; {
    description = "A Scheme shell";
    homepage = http://www.scsh.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
