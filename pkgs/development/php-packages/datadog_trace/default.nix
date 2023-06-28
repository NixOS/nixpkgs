{ buildPecl, curl, fetchFromGitHub, lib, pcre2, php }:

buildPecl rec {
  pname = "ddtrace";
  version = "0.82.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-trace-php";
    rev = version;
    sha256 = "sha256-QTqZRHh57mRkg0HT9qQS13emGobB0IRqM+mdImAPgtE=";
  };

  buildInputs = [ curl pcre2 ];

  meta = with lib; {
    description = "Datadog Tracing PHP Client";
    homepage = "https://github.com/DataDog/dd-trace-php";
    license = with licenses; [ asl20 /* or */ bsd3 ];
    maintainers = teams.php.members;
  };
}
