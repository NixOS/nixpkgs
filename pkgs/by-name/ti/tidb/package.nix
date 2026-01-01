{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tidb";
<<<<<<< HEAD
  version = "8.5.4";
=======
  version = "8.5.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-8YlN49XPplEAk1RwqB+2fXyTMIAFXt5W0CGOE0hc3PQ=";
  };

  vendorHash = "sha256-fVY34aZCaxGh6OXV9oEkdEtJpXqyaQjxH0v6Xfpokz4=";
=======
    sha256 = "sha256-2pg3UxzxzB4V4XhfmSxQCOn+NFqvp7DF+htIY3mtZ4s=";
  };

  vendorHash = "sha256-HXN2EkpN2ltBUB2HqSvUOgVTfs2zcTeHoxa5zpccc+A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X github.com/pingcap/tidb/pkg/parser/mysql.TiDBReleaseVersion=${version}"
    "-X github.com/pingcap/tidb/pkg/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "cmd/tidb-server" ];

<<<<<<< HEAD
  meta = {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Makuru ];
=======
  meta = with lib; {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ Makuru ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "tidb-server";
  };
}
