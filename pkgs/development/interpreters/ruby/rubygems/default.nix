{ stdenv, lib, fetchurl }:

let generic = { version, sha256 }: stdenv.mkDerivation {
  name = "rubygems";
  inherit version;

  src = fetchurl {
    url = "https://rubygems.org/rubygems/rubygems-${version}.tgz";
    inherit sha256;
  };

  patches = [
    ./0001-add-post-extract-hook.patch
    ./0002-binaries-with-env-shebang.patch
    ./0003-gem-install-default-to-user.patch
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Package management framework for Ruby";
    homepage = https://rubygems.org/;
    license = with licenses; [ mit /* or */ ruby ];
    maintainers = with maintainers; [ qyliss zimbatm ];
  };
};
in {
  rubygems_3_0 = generic {
    version = "3.0.6";
    sha256 = "1ca1i4xmggizr59m6p28gprlvshczsbx30q8iyzxb2vj4jn8arzx";
  };
  rubygems_3_1 = generic {
    version = "3.1.2";
    sha256 = "0h7ij4jpj8rgnpkl63cwh2lnav73pw5wpfqra3va7077lsyadlgd";
  };
}
