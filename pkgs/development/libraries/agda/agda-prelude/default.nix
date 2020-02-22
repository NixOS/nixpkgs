{ stdenv, agda, fetchgit }:

agda.mkDerivation (self: rec {
  version = "eacc961c2c312b7443109a7872f99d55557df317";
  name = "agda-prelude-${version}";

  src = fetchgit {
    url = "https://github.com/UlfNorell/agda-prelude.git";
    rev = version;
    sha256 = "0iql67hb1q0fn8dwkcx07brkdkxqfqrsbwjy71ndir0k7qzw7qv2";
  };

  topSourceDirectories = [ "src" ];
  everythingFile = "src/Prelude.agda";

  meta = with stdenv.lib; {
    homepage = https://github.com/UlfNorell/agda-prelude;
    description = "Programming library for Agda";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ mudri ];
  };
})
