{ lib
, boto3
, buildPythonPackage
, pythonOlder
, typing-extensions
, fetchPypi
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildMypyBoto3Package = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "mypy-boto3-${serviceName}";
      inherit version;
      format = "setuptools";

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      propagatedBuildInputs = [
        boto3
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "mypy_boto3_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ fab mbalatsko ];
      };
    };
in
rec {
  mypy-boto3-accessanalyzer = buildMypyBoto3Package "accessanalyzer" "1.28.36" "sha256-1gfL7x81tTVZlYL8UwoI5k8pDotu1byCWqP31CruRIo=";

  mypy-boto3-account = buildMypyBoto3Package "account" "1.28.36" "sha256-RDGy7V+YgVlGufL+bFJ1xR5yi4xc2zkV+gTBdXdwkxk=";

  mypy-boto3-acm = buildMypyBoto3Package "acm" "1.28.37" "sha256-NDYWiS7MM7z6mCpRASWh42IGsSTUvVzIJU0eH5V7JUI=";

  mypy-boto3-acm-pca = buildMypyBoto3Package "acm-pca" "1.28.37" "sha256-l79J8dndeHBZTdXhYCUSa39lYFgcgM6/lIUQPx4HbRE=";

  mypy-boto3-alexaforbusiness = buildMypyBoto3Package "alexaforbusiness" "1.28.37" "sha256-Rk2BLp1oqwOG+Rd9lal53RArPjIo1XMkmXhZJLiI6Ik=";

  mypy-boto3-amp = buildMypyBoto3Package "amp" "1.28.36" "sha256-/iFfYQ2hwndbtOPnFx5GopCNOYi4uAAOTbD8Z8xFOoE=";

  mypy-boto3-amplify = buildMypyBoto3Package "amplify" "1.28.36" "sha256-ORwKl4j3M+O9a/JVrfal2lCBOe8QEcjAWscEhRqPrxc=";

  mypy-boto3-amplifybackend = buildMypyBoto3Package "amplifybackend" "1.28.36" "sha256-tx837SLt7DL1bD/bZl0egzVpClfJKaSY6p82yrcHWRQ=";

  mypy-boto3-amplifyuibuilder = buildMypyBoto3Package "amplifyuibuilder" "1.28.54" "sha256-5Y2AacuMzVHdPntUyDts21bUzttM9t8EdBcwV1MHhyU=";

  mypy-boto3-apigateway = buildMypyBoto3Package "apigateway" "1.28.36" "sha256-5GDltAso++KS+EKZPnvzrVFNAHN3SzDxxeE33mq6xoE=";

  mypy-boto3-apigatewaymanagementapi = buildMypyBoto3Package "apigatewaymanagementapi" "1.28.36" "sha256-yh5Xd7rKl6eUZBvnqgVU3BEThbIoVOWA15UEYoFicLo=";

  mypy-boto3-apigatewayv2 = buildMypyBoto3Package "apigatewayv2" "1.28.36" "sha256-ZSj0PoLQaUtqd0qLzU+Eg3YG0q6GwWEitKZCTfYergI=";

  mypy-boto3-appconfig = buildMypyBoto3Package "appconfig" "1.28.52" "sha256-OjHFaTlMso7dbUCyNfOtbIgpRQYmVm7n0PoUZjOaf18=";

  mypy-boto3-appconfigdata = buildMypyBoto3Package "appconfigdata" "1.28.36" "sha256-dGBUpgH/1QQ3nGxhkLWBW06ngmr+Iq2v9MqjrZ0vP1k=";

  mypy-boto3-appfabric = buildMypyBoto3Package "appfabric" "1.28.36" "sha256-WN7nEPs2KweoGu7XUycFpp8i/bOWSlcr+6BZFSFh6KM=";

  mypy-boto3-appflow = buildMypyBoto3Package "appflow" "1.28.42" "sha256-zUqO8SGKoA9umP2iKrw5VXC4pBBVqs4D9Ou/lJwEVBI=";

  mypy-boto3-appintegrations = buildMypyBoto3Package "appintegrations" "1.28.55" "sha256-Sii5aQ9Y1YvpW1QLMXOeboLXzSR7RCZA6hDGvI39yWM=";

  mypy-boto3-application-autoscaling = buildMypyBoto3Package "application-autoscaling" "1.28.36" "sha256-sxkmyfgk3FJPrS9SUJrHA4tNADM8g+wGaEEPnZjv2H4=";

  mypy-boto3-application-insights = buildMypyBoto3Package "application-insights" "1.28.36" "sha256-jNzhi3ashmQFH7QRi28UY5ZZ/su8RwzhU1XzmunOiro=";

  mypy-boto3-applicationcostprofiler = buildMypyBoto3Package "applicationcostprofiler" "1.28.36" "sha256-keA+JdfyJVGf388qcA0HTIq9bUiMeEbcg1/s/SI7mt4=";

  mypy-boto3-appmesh = buildMypyBoto3Package "appmesh" "1.28.36" "sha256-1Cf+Mzgg0KDqBRpCWeCR0lbR5q8KJM+p/p2we6925b0=";

  mypy-boto3-apprunner = buildMypyBoto3Package "apprunner" "1.28.55" "sha256-lBbqHhOqWoudqK4NDFNSpzR/UA/dLCHzFmZWQSNhJLY=";

  mypy-boto3-appstream = buildMypyBoto3Package "appstream" "1.28.49" "sha256-5TgCIA4bbUHgxMcLHrWPEyIIYhjlCXZlvW8mYubA0+I=";

  mypy-boto3-appsync = buildMypyBoto3Package "appsync" "1.28.36" "sha256-Qag3caLiBRlUWl+TbUQjGkoAbQk+CEbuzZAJgq21PdE=";

  mypy-boto3-arc-zonal-shift = buildMypyBoto3Package "arc-zonal-shift" "1.28.36" "sha256-hTGtmMTWhsMqo+Vq2Bxtfo1sGezi1vD05LsQyGOl9Ps=";

  mypy-boto3-athena = buildMypyBoto3Package "athena" "1.28.36" "sha256-p232qs49wdkbP3RkDWF80bSALl80iiLbLxbfzgsB7iY=";

  mypy-boto3-auditmanager = buildMypyBoto3Package "auditmanager" "1.28.38" "sha256-t32bXFUOsVNVs+1Sagx2PIO7/Re6gN2cOevLj+7gbqo=";

  mypy-boto3-autoscaling = buildMypyBoto3Package "autoscaling" "1.28.36" "sha256-3b2iUNeY/8ZcZZsyqHTNTsGMwWBxCeiOm+1Tpq+iYf8=";

  mypy-boto3-autoscaling-plans = buildMypyBoto3Package "autoscaling-plans" "1.28.36" "sha256-Hx/rpODs11SdfZTQTcOYAIsPbiLDpreqLdbBHGIEp5E=";

  mypy-boto3-backup = buildMypyBoto3Package "backup" "1.28.36" "sha256-LbGiDazOf32hEoxGTZlTtH9iTj+3ru+sCO0VAMCfN6E=";

  mypy-boto3-cognito-idp = buildMypyBoto3Package "cognito-idp" "1.28.36" "sha256-pnLO62LZvr4sJsye3gWJROY+xHikSe7dX8erBTRXrPc=";

  mypy-boto3-ebs = buildMypyBoto3Package "ebs" "1.28.36" "sha256-w9OLKJAn9UBnA7x+uedhplSV8plZRYlBpviU9Gv1Ny8=";

  mypy-boto3-s3 = buildMypyBoto3Package "s3" "1.28.55" "sha256-sAiAn0SOdAdQEtT8VLAXbeC09JvDjjneMMoOdk63UFY=";

  mypy-boto3-xray = buildMypyBoto3Package "xray" "1.28.47" "sha256-1OiTpbaBm2aAls4A7ZaZBNAM8DTRuQcwNKJDq3lOKMY=";

}
