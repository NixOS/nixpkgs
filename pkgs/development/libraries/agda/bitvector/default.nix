{ stdenv, agda, fetchgit, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "f1c173313f2a41d95a8dc6053f9365a24690e18d";
  name = "bitvector-${version}";

  src = fetchgit {
    url = "https://github.com/copumpkin/bitvector.git";
    rev = version;
    sha256 = "0jb421lxvyxz26sxa81qjmn1gfcxfh0fmbq128f0kslqhiiaqfrh";
  };

  buildDepends = [ AgdaStdlib ];
  sourceDirectories = [ "Data" ];

  meta = {
    homepage = https://github.com/copumpkin/bitvector;
    description = "Sequences of bits and common operations on them";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    broken = true;
  };
})
