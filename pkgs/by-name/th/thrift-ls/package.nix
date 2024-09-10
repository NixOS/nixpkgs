{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "thrift-ls";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "joyme123";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qib/xbTQiR0VpHsCOt5HGkbytaQ0GSCqaHVYFNPYGVs=";
  };

  vendorHash = "sha256-YoZ2dku84065Ygh9XU6dOwmCkuwX0r8a0Oo8c1HPsS4=";

  postInstall = ''
    mv $out/bin/thrift-ls $out/bin/thriftls
  '';

  meta = with lib; {
    description = "Language server for Thrift";
    homepage = "https://github.com/joyme123/thrift-ls";
    license = licenses.asl20;
    maintainers = with maintainers; [
      callumio
      hughmandalidis
    ];
    platforms = platforms.unix;
  };
}
