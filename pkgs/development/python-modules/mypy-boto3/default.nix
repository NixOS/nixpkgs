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

  mypy-boto3-backup-gateway = buildMypyBoto3Package "backup-gateway" "1.28.36" "sha256-AGbffUSt3ndl5a0B5nl9CYgYExaM1JLT53T9jVJxeno=";

  mypy-boto3-backupstorage = buildMypyBoto3Package "backupstorage" "1.28.36" "sha256-Km6lRkCrsWep/kAlPXplbyfHyy5D5nnrd0j0v8FID00=";

  mypy-boto3-batch = buildMypyBoto3Package "batch" "1.28.36" "sha256-SEDD3Fjd4y337atj+RVUKIvpUd0oCvje8gOF1/Rg7Gs=";

  mypy-boto3-billingconductor = buildMypyBoto3Package "billingconductor" "1.28.41" "sha256-aUphZNHrTLUt4dOvg+GmZR7z3whq5jx2PVsjvcY0qS0=";

  mypy-boto3-braket = buildMypyBoto3Package "braket" "1.28.53" "sha256-fMNDKmjx/2hUJHWEWcveYbsbIkiWUXTQSv4itP8zOas=";

  mypy-boto3-budgets = buildMypyBoto3Package "budgets" "1.28.57" "sha256-Af6omXHyctUeXbEOQC/KoiE3ux88r/hyxlWQoMM1eF4=";

  mypy-boto3-ce = buildMypyBoto3Package "ce" "1.28.36" "sha256-lBrKm4s1QPGTuZHtHt+uNhX9zsMhNuV0l23822IYIDI=";

  mypy-boto3-chime = buildMypyBoto3Package "chime" "1.28.37" "sha256-fg8svfLvw+Rzhcr+HxrjHtXw9UE1vuccaOFvjfgxC58=";

  mypy-boto3-chime-sdk-identity = buildMypyBoto3Package "chime-sdk-identity" "1.28.37" "sha256-r+UvZ213ffIOdmZ1V8MNtZN/i3ozeKfwv7VIvJZ4CRg=";

  mypy-boto3-chime-sdk-media-pipelines = buildMypyBoto3Package "chime-sdk-media-pipelines" "1.28.54" "sha256-ewC4woDpDkGUBvPgjpcctkO860EJWHGvZrgCgXSsPbA=";

  mypy-boto3-chime-sdk-meetings = buildMypyBoto3Package "chime-sdk-meetings" "1.28.36" "sha256-OZijI8aLKnnZnXf3q8LmePd9ncIrDj2zRq19tNlNQTk=";

  mypy-boto3-chime-sdk-messaging = buildMypyBoto3Package "chime-sdk-messaging" "1.28.37" "sha256-qMLqjzniJfyVCfnMGiIPMRzQoIj309P5WDBjy1P7B8Y=";

  mypy-boto3-chime-sdk-voice = buildMypyBoto3Package "chime-sdk-voice" "1.28.36" "sha256-e627SiCiQV38AzvYusuNEsD9XoYkTYYbaTMJ2odKzAo=";

  mypy-boto3-cleanrooms = buildMypyBoto3Package "cleanrooms" "1.28.38" "sha256-fbuCwuzXiK9ekk30m90WZW7LcDFLeR/Ta9BvFnT/wnU=";

  mypy-boto3-cloud9 = buildMypyBoto3Package "cloud9" "1.28.47" "sha256-vV+cqYs7msRzBkIIz4uA123QM54gFpi1q9lXo997BOk=";

  mypy-boto3-cloudcontrol = buildMypyBoto3Package "cloudcontrol" "1.28.36" "sha256-DshOzjolyUCztdlOqxxvRlKIIJP6izeyhp2Wl6ObCrY=";

  mypy-boto3-clouddirectory = buildMypyBoto3Package "clouddirectory" "1.28.36" "sha256-ikyPoBWFRXl95QylMg3rstBymj3HKZqQs0orb14Uorg=";

  mypy-boto3-cloudformation = buildMypyBoto3Package "cloudformation" "1.28.48" "sha256-775Aczl4AIJCh8jVKmU4MRKGL5A7Fv1Ye1ETRJZSNxs=";

  mypy-boto3-cloudfront = buildMypyBoto3Package "cloudfront" "1.28.36" "sha256-lY3dwCA/xw6YIgmmJeglC3/mHubiKNqPqrrif6ZreDc=";

  mypy-boto3-cloudhsm = buildMypyBoto3Package "cloudhsm" "1.28.39" "sha256-1K3HPvtZSkQZD5/V9T0tXv6PC2NSoB5v5aR20OWV6kw=";

  mypy-boto3-cloudhsmv2 = buildMypyBoto3Package "cloudhsmv2" "1.28.36" "sha256-mxvW/ge2gEkGF0rz4LJZCkEIveNGkt9ud5bqs4WhlBs=";

  mypy-boto3-cloudsearch = buildMypyBoto3Package "cloudsearch" "1.28.36" "sha256-fEGcYuWWDHOalygjig2qdMn8A3T4vBYZIbZRHtRRQns=";

  mypy-boto3-cloudsearchdomain = buildMypyBoto3Package "cloudsearchdomain" "1.28.36" "sha256-yRUv7XlIpCqkyFw+whHh07LUw0aKbcRa0UkR6zpVtCA=";

  mypy-boto3-cloudtrail = buildMypyBoto3Package "cloudtrail" "1.28.36" "sha256-YUrRZ53Wdd4CCjq9VYRkAIGxu2wYTaqXF7Fp4DA7jM4=";

  mypy-boto3-cognito-idp = buildMypyBoto3Package "cognito-idp" "1.28.36" "sha256-pnLO62LZvr4sJsye3gWJROY+xHikSe7dX8erBTRXrPc=";

  mypy-boto3-ebs = buildMypyBoto3Package "ebs" "1.28.36" "sha256-w9OLKJAn9UBnA7x+uedhplSV8plZRYlBpviU9Gv1Ny8=";

  mypy-boto3-s3 = buildMypyBoto3Package "s3" "1.28.55" "sha256-sAiAn0SOdAdQEtT8VLAXbeC09JvDjjneMMoOdk63UFY=";

  mypy-boto3-xray = buildMypyBoto3Package "xray" "1.28.47" "sha256-1OiTpbaBm2aAls4A7ZaZBNAM8DTRuQcwNKJDq3lOKMY=";

}
