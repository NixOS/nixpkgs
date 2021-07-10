{ lib, fetchFromGitHub }:

{
  version = "2021-16-16-aec0ac6";

  src = fetchFromGitHub {
    owner = "reasonml";
    repo = "reason-native";
    rev = "aec0ac681be7211b4d092262281689c46deb63e1";
    sha256 = "sha256-QoyI50MBY3RJBmM1y90n7oXrLmHe0CQxKojv+7YbegE=";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Libraries for building and testing native Reason programs";
    downloadPage = "https://github.com/reasonml/reason-native";
    homepage = "https://reason-native.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
}
