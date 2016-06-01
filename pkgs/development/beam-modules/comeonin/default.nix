{stdenv, fetchFromGitHub, beamPackages }:

beamPackages.buildMix {
  name = "comeonin";
  version = "2.4.0";

  src = fetchFromGitHub {
      owner = "elixircnx";
      repo = "comeonin";
      rev = "a158b18e52fac1adc715d9b0f7cd6efe6336b73b";
      sha256 = "0sw2zlpa391s31xna2kg6500bhcznwsmhpjydynkdbcswiy74nhx";
  };

  beamDeps = [ beamPackages.earmark beamPackages.ex_doc ];

  meta = {
    description = "Password hashing (bcrypt, pbkdf2_sha512) library for Elixir";
    license = stdenv.lib.licenses.bsd;
    homepage = "https://github.com/elixircnx/comeonin";
    maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
  };
}
