{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, symlinkJoin
}:

let p2 = buildGoModule rec {
  pname = "packr2";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = "packr";
    rev = "v${version}";
    hash = "sha256-UfnL3Lnq3ocXrTqKtmyar6BoKUUHHKMOFCiD5wX26PQ=";
  }+"/v2";

  subPackages = [ "packr2" ];

  vendorHash = "sha256-N3u+DmEe0r72zFPb8El/MwjyIcTehQRE+MgusIII2Is=";

  doCheck = false;

  meta = with lib; {
    description = "Simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];

    # golang.org/x/sys needs to be updated due to:
    #
    #   https://github.com/golang/go/issues/49219
    #
    # but this package is no longer maintained.
    #
    broken = stdenv.isDarwin;
  };
};
p1 = buildGoModule rec {
  pname = "packr1";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = "packr";
    rev = "v${version}";
    hash = "sha256-UfnL3Lnq3ocXrTqKtmyar6BoKUUHHKMOFCiD5wX26PQ=";
  };

  subPackages = [ "packr" ];

  vendorHash = "sha256-6mlV3q7irI0aoeB91OYSD3RvmwYcNXRNkSYowjmSflQ=";

  doCheck = false;

  meta = with lib; {
    description = "Simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];

    # golang.org/x/sys needs to be updated due to:
    #
    #   https://github.com/golang/go/issues/49219
    #
    # but this package is no longer maintained.
    #
    broken = stdenv.isDarwin;
  };
};
in
symlinkJoin{
    name = "packr";
    paths = [p1 p2];
}
