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

  mypy-boto3-cloudtrail-data = buildMypyBoto3Package "cloudtrail-data" "1.28.36" "sha256-aUZYh0fTrcv1d56HRdu7u4CzAMiCvVlN/tKY1e7piLM=";

  mypy-boto3-cloudwatch = buildMypyBoto3Package "cloudwatch" "1.28.36" "sha256-108mLOQPp+qUdIBWHlN2UO5pRrIIrAf2wM/a/BYAFEM=";

  mypy-boto3-codeartifact = buildMypyBoto3Package "codeartifact" "1.28.52" "sha256-kmPzmdQj79l+8KY7Q/E4qTxCxAEhEPivYiR1Hh04qm0=";

  mypy-boto3-codebuild = buildMypyBoto3Package "codebuild" "1.28.36" "sha256-po4qcd6jiYjqMQj7aP+eMzNJcmwjYP22Q92fHkx1q5U=";

  mypy-boto3-codecatalyst = buildMypyBoto3Package "codecatalyst" "1.28.36" "sha256-IuFxPWpE6zCGfbVfhTBtueUSspeVaq9TrESkfHdrxI8=";

  mypy-boto3-codecommit = buildMypyBoto3Package "codecommit" "1.28.36" "sha256-o/kVzldUZNfMmK3Ni5L0kOLjKLxsB93YwutqM5GvHqQ=";

  mypy-boto3-codedeploy = buildMypyBoto3Package "codedeploy" "1.28.55" "sha256-jkN9DCiS5fKhBq7752gRzHwmfdohQBZOSNGaA1OxVbc=";

  mypy-boto3-codeguru-reviewer = buildMypyBoto3Package "codeguru-reviewer" "1.28.36" "sha256-xUkKfYEBmqA0D8RKxbf8VF0XeYOgwNWh1y7ORnj1VpM=";

  mypy-boto3-codeguru-security = buildMypyBoto3Package "codeguru-security" "1.28.36" "sha256-EU6VTdhzWLofMEFF0vOXTDpJI/BkC3FpSAz1rbtbFWA=";

  mypy-boto3-codeguruprofiler = buildMypyBoto3Package "codeguruprofiler" "1.28.36" "sha256-DHUALwX0ec7rzaSsU0vASersuuHpJXY8cDI8cDhzgl0=";

  mypy-boto3-codepipeline = buildMypyBoto3Package "codepipeline" "1.28.36" "sha256-isqRkPLovlkHgmBuuYDPBTaBlOdu3LgwajD+z3luO8c=";

  mypy-boto3-codestar = buildMypyBoto3Package "codestar" "1.28.36" "sha256-+D1SBuI6JMA0ISBv5OiGkA43dOESGH4d4m8CUN4Uhxk=";

  mypy-boto3-codestar-connections = buildMypyBoto3Package "codestar-connections" "1.28.36" "sha256-1K0mrUUO0ycP7uBCqnESd/iGiElL0eqJfwLTpgPH5a0=";

  mypy-boto3-codestar-notifications = buildMypyBoto3Package "codestar-notifications" "1.28.36" "sha256-BYTeNmL6fKXD6Ym0Z3DOZvLaTqRwANDWfCcWs9TUZ+Y=";

  mypy-boto3-cognito-identity = buildMypyBoto3Package "cognito-identity" "1.28.36" "sha256-fJIKiNsKDcoDtTIRMxbxpcO6QZOl8KnCn2qTkb4owLI=";

  mypy-boto3-cognito-idp = buildMypyBoto3Package "cognito-idp" "1.28.36" "sha256-pnLO62LZvr4sJsye3gWJROY+xHikSe7dX8erBTRXrPc=";

  mypy-boto3-cognito-sync = buildMypyBoto3Package "cognito-sync" "1.28.36" "sha256-Hx+/3Q+FLMeDRu+ijTl80WbmqjW/jzpW8eDar8hu/ro=";

  mypy-boto3-comprehend = buildMypyBoto3Package "comprehend" "1.28.37" "sha256-OK8LtQoV2Ccqc4qjRBNJirRDM8wHR7VDzcgbaJNrGok=";

  mypy-boto3-comprehendmedical = buildMypyBoto3Package "comprehendmedical" "1.28.36" "sha256-6uyeuxkhRD5Xpfh5u09U28Zg1OzLyzwhgQZ/LRGI9lc=";

  mypy-boto3-compute-optimizer = buildMypyBoto3Package "compute-optimizer" "1.28.41" "sha256-TYY9yrw8Az+x01fp3mXc2zzX7YBdnAQQr1uy+E8FkdQ=";

  mypy-boto3-config = buildMypyBoto3Package "config" "1.28.36" "sha256-3NUJLfbriTXMsGyj+8XNbhI37BLVSm+sShaJJIz6I7s=";

  mypy-boto3-connect = buildMypyBoto3Package "connect" "1.28.55" "sha256-sA6ef9iOyRrCKwxsSHU19IaBwYiVKeTR0+k94wUX4gw=";

  mypy-boto3-connect-contact-lens = buildMypyBoto3Package "connect-contact-lens" "1.28.36" "sha256-7+DHcEkDov1/0mNu/mbKaCwwPfvGRYSEfp3+4tnOnuY=";

  mypy-boto3-connectcampaigns = buildMypyBoto3Package "connectcampaigns" "1.28.39" "sha256-4c074TlgMh8YxdOl9vb+Xs0JEs5k0mA5rYaF+BIH3Ps=";

  mypy-boto3-connectcases = buildMypyBoto3Package "connectcases" "1.28.36" "sha256-oYU/yw9CUltwPfvONhCvH6gCXirzKF26RZj9hdKTtPQ=";

  mypy-boto3-connectparticipant = buildMypyBoto3Package "connectparticipant" "1.28.39" "sha256-iOv8UX4eh07Dwk7zvtv1YXeDiX/RHhuEMGzLafBk+kI=";

  mypy-boto3-controltower = buildMypyBoto3Package "controltower" "1.28.36" "sha256-0j6Fa0hobGlNfvMDmlNrqp4EqIhnYTo9XJ41VpEY+Cs=";

  mypy-boto3-cur = buildMypyBoto3Package "cur" "1.28.36" "sha256-pWKHl8zKmx3ypQOiWtFzRb92630sLJVO0qmn5KEZJ14=";

  mypy-boto3-customer-profiles = buildMypyBoto3Package "customer-profiles" "1.28.39" "sha256-wAghxGUIThqLBfThNliSu39Dl8vmO8QCrfbxvQOuHxc=";

  mypy-boto3-databrew = buildMypyBoto3Package "databrew" "1.28.36" "sha256-LhvgmeMOlP4EAmx3Xd97ZiHi/FeChpGtZ1LIuGkTnMU=";

  mypy-boto3-dataexchange = buildMypyBoto3Package "dataexchange" "1.28.36" "sha256-cNgpRQTJ2JhPw+UZo+HiulWg1998kfgnAB/E6gyvetI=";

  mypy-boto3-datapipeline = buildMypyBoto3Package "datapipeline" "1.28.36" "sha256-IkO7QXwdEWmkzaCOrCWTzNv1xpvwOHGp9wlris/KEws=";

  mypy-boto3-datasync = buildMypyBoto3Package "datasync" "1.28.49" "sha256-BcW47DW0aHb+Gabj6fybaiZgtKotWNvNChyKyaagIw4=";

  mypy-boto3-dax = buildMypyBoto3Package "dax" "1.28.36" "sha256-t5DMgU3iSxWLSXpC9QaNonKKQpl0tr/gQPnPxO+dTbY=";

  mypy-boto3-detective = buildMypyBoto3Package "detective" "1.28.36" "sha256-RGSt2jtwDqC3qWh+Z6IfWoiVpoLDjSqLTSjo7+SUL3Q=";

  mypy-boto3-devicefarm = buildMypyBoto3Package "devicefarm" "1.28.36" "sha256-TSxUsHAhGY4rgscwesf6mnlya8kHb6MZGKPzhud/OC0=";

  mypy-boto3-devops-guru = buildMypyBoto3Package "devops-guru" "1.28.36" "sha256-Whn1VVBzBdav0D31XCH5izyVmZGg/ndPlOamIoY5U94=";

  mypy-boto3-directconnect = buildMypyBoto3Package "directconnect" "1.28.36" "sha256-YUZ2XsKaPLi4qDF1Cuf5/6BZ1Pi+xf65hTBc0NHfQTc=";

  mypy-boto3-discovery = buildMypyBoto3Package "discovery" "1.28.50" "sha256-bUFzZ+Ipw3hmaTvBBPlLRz48U+alvfLBiOKNljEap38=";

  mypy-boto3-dlm = buildMypyBoto3Package "dlm" "1.28.36" "sha256-i+OVrnJ+irxgIWi0ZEad6lPLNwT1cvfQ+0xKKXWe8z0=";

  mypy-boto3-dms = buildMypyBoto3Package "dms" "1.28.53" "sha256-CY3bGLiiciRnscCsqOSdFv04YKDG4gN7f/q3um7QwZ8=";

  mypy-boto3-docdb = buildMypyBoto3Package "docdb" "1.28.36" "sha256-Dbg80rvJBHkXEzLLWeEi7jN6OrVZiJ6+C6wYkhM72J0=";

  mypy-boto3-docdb-elastic = buildMypyBoto3Package "docdb-elastic" "1.28.36" "sha256-XvcexadEtui/Wh2sZnketqygNgpGfaSAGciM64Yc+Sk=";

  mypy-boto3-drs = buildMypyBoto3Package "drs" "1.28.47" "sha256-4JBlsWQLu1KsPSTxwy/ySNQM1ZlIaX1sORvES8Lut00=";

  mypy-boto3-ds = buildMypyBoto3Package "ds" "1.28.36" "sha256-l/k+1VhA6mi6mVRKCUis0gAv/dizqZB5JIqLmj9+IDI=";

  mypy-boto3-dynamodb = buildMypyBoto3Package "dynamodb" "1.28.55" "sha256-owOfitoHohj5fwxwqC7Zz0YaDLUTMZT88eDoexXImaU=";

  mypy-boto3-dynamodbstreams = buildMypyBoto3Package "dynamodbstreams" "1.28.36" "sha256-mqz+YRVZlSbwEKYbaC4ZbWw0qJTXpRObAphfI4sfRV4=";

  mypy-boto3-ebs = buildMypyBoto3Package "ebs" "1.28.36" "sha256-w9OLKJAn9UBnA7x+uedhplSV8plZRYlBpviU9Gv1Ny8=";

  mypy-boto3-ec2 = buildMypyBoto3Package "ec2" "1.28.58" "sha256-p4BGJSydAqtSMH8PFFc/IAwBquLHCq1I6vW50UNySRo=";

  mypy-boto3-ec2-instance-connect = buildMypyBoto3Package "ec2-instance-connect" "1.28.36" "sha256-oVcd5yqbg8Drozgmog4nonRSe4nOM7rwpqZi9HVYTL0=";

  mypy-boto3-ecr = buildMypyBoto3Package "ecr" "1.28.45" "sha256-NYShmgGLrNe26BR7ye9pMpZ4FcCRjGzzkp/1Xxyb5gE=";

  mypy-boto3-ecr-public = buildMypyBoto3Package "ecr-public" "1.28.36" "sha256-LiFZtqdGf9tC6Tj4ukclFyaq/bLos5jZCgPL1y/0VMU=";

  mypy-boto3-ecs = buildMypyBoto3Package "ecs" "1.28.41" "sha256-/aXw4fpS4o3/Jt+jfzm0p4zqZVcoSJLlk9EUMd3+SVo=";

  mypy-boto3-efs = buildMypyBoto3Package "efs" "1.28.53" "sha256-QhSddCRqWUly2w+GLZJHJn/TKpQHbQO88yKny6nj/ZI=";

  mypy-boto3-eks = buildMypyBoto3Package "eks" "1.28.36" "sha256-etvfyKLFr4lKE9DLvKQuHw2YHshhOBTXXTCvDv2hFxE=";

  mypy-boto3-elastic-inference = buildMypyBoto3Package "elastic-inference" "1.28.36" "sha256-BwI32rA8Y1lhc+k/XQh+LHPlFHmaCTr37OYvLFJMX1o=";

  mypy-boto3-elasticache = buildMypyBoto3Package "elasticache" "1.28.36" "sha256-6Ymobcuhh1dOqA9IoN9lWrj639ZKu/NQEP6ImlhapFA=";

  mypy-boto3-elasticbeanstalk = buildMypyBoto3Package "elasticbeanstalk" "1.28.36" "sha256-V2vSEaN7Kf2TPateMNtJ95a+Ad/CRcZOV2JsJlTOPIo=";

  mypy-boto3-elastictranscoder = buildMypyBoto3Package "elastictranscoder" "1.28.36" "sha256-lkz4up43fVyWCOO9dM4xI285wsAu1lnV4mICuJV8D4k=";

  mypy-boto3-elb = buildMypyBoto3Package "elb" "1.28.36" "sha256-c9Re0WZOn+LaK58VJk+YlI3YWn/wrgT+/TdqrOisBnM=";

  mypy-boto3-elbv2 = buildMypyBoto3Package "elbv2" "1.28.42" "sha256-NXyhMxuIbuyyDifzBicvDNQB3ysbVx+azsqpTBhfnZ8=";

  mypy-boto3-emr = buildMypyBoto3Package "emr" "1.28.36" "sha256-DrhDkqcxAAUTfheZRpPJQkFFzeDynByF2wn9jyZr0F4=";

  mypy-boto3-emr-containers = buildMypyBoto3Package "emr-containers" "1.28.36" "sha256-ZG7mf4C31COK7hobIbTLmd64Ydu2Al+NhSMrS8069jQ=";

  mypy-boto3-emr-serverless = buildMypyBoto3Package "emr-serverless" "1.28.54" "sha256-cDbUY1Ftlhyid7CiMEhY7ZepqH2bANrwlU8wdrdDqc4=";

  mypy-boto3-entityresolution = buildMypyBoto3Package "entityresolution" "1.28.48" "sha256-xCYg+Ik/VQpDjRR7QKlYyBffsGWZ7PSl531sTSvMv48=";

  mypy-boto3-es = buildMypyBoto3Package "es" "1.28.36" "sha256-NfMTzKYwYgZ+dbyIzxn+3poLWo8zjF8ANGWQFtMRTbk=";

  mypy-boto3-events = buildMypyBoto3Package "events" "1.28.46" "sha256-/a4rUcfBPQBFxqCnwt23NeZ655B3CEoo+SKHBZMJGtE=";

  mypy-boto3-evidently = buildMypyBoto3Package "evidently" "1.28.36" "sha256-U3igtB9eGBYv8VW+PQXD2fc16FKiYl8musH/ccrrMKA=";

  mypy-boto3-finspace = buildMypyBoto3Package "finspace" "1.28.36" "sha256-3l1/ACy5Z09z/ngQKdq3dgBTp05x+NUCRjj1z8I99/4=";

  mypy-boto3-finspace-data = buildMypyBoto3Package "finspace-data" "1.28.54" "sha256-V5Rxrp94hrUWZgpc+LDn1PwyzZREHDXq3NaZdZQaYoE=";

  mypy-boto3-firehose = buildMypyBoto3Package "firehose" "1.28.56" "sha256-IPwUkzEymLJ4NgB2OrD4mr5hZsmTaGjbbxCiHyFaaDw=";

  mypy-boto3-fis = buildMypyBoto3Package "fis" "1.28.36" "sha256-km9Ia9Hs/rZv3ljv+BVnR9pOxNK3u5luJOMaW670km0=";

  mypy-boto3-fms = buildMypyBoto3Package "fms" "1.28.36" "sha256-mzumkMcF2TMrcnHoPPA0SlrmwFAw0TR1cMvSXF28gvM=";

  mypy-boto3-forecast = buildMypyBoto3Package "forecast" "1.28.36" "sha256-DCa0GNn7XL3iVgGl5M6E7uyPFdyYjrHfqHakCS7clcc=";

  mypy-boto3-forecastquery = buildMypyBoto3Package "forecastquery" "1.28.36" "sha256-s2z8QZR9PP8Kj6yImCwUfh/gtbj4SKLn8wDTOYUVaEE=";

  mypy-boto3-frauddetector = buildMypyBoto3Package "frauddetector" "1.28.36" "sha256-Zn3rGHErin7nPYnyC0Ojr0Kkc5T+YDD2KmZinYNV9Jg=";

  mypy-boto3-fsx = buildMypyBoto3Package "fsx" "1.28.44" "sha256-t90+ngxgivF/KThwaB6/LNPZAHL2oLenhl6KUzSZSzU=";

  mypy-boto3-gamelift = buildMypyBoto3Package "gamelift" "1.28.36" "sha256-ADxlyEX5KgAewNFq7JhYECNIhaoKiPkdqWK2pnS+65A=";

  mypy-boto3-gamesparks = buildMypyBoto3Package "gamesparks" "1.28.36" "sha256-6lQXNJ55FYvkFA14rgJGhRMjBHA3YrOybnsKNecX7So=";

  mypy-boto3-glacier = buildMypyBoto3Package "glacier" "1.28.36" "sha256-L0a7CoD9I0wM8JvzaAxL8bm1SV1XmFi5lvs2SuGPtl4=";

  mypy-boto3-globalaccelerator = buildMypyBoto3Package "globalaccelerator" "1.28.36" "sha256-+nnFS/7kJHvqqiwqkWnYlgeIuSecicI1P+UtWyGUoGQ=";

  mypy-boto3-s3 = buildMypyBoto3Package "s3" "1.28.55" "sha256-sAiAn0SOdAdQEtT8VLAXbeC09JvDjjneMMoOdk63UFY=";

  mypy-boto3-xray = buildMypyBoto3Package "xray" "1.28.47" "sha256-1OiTpbaBm2aAls4A7ZaZBNAM8DTRuQcwNKJDq3lOKMY=";

}
