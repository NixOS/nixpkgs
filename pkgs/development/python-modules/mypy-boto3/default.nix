{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, typing-extensions
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildMypyBoto3Package = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "mypy-boto3-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      build-system = [
        setuptools
      ];

      dependencies = [
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
  mypy-boto3-accessanalyzer = buildMypyBoto3Package "accessanalyzer" "1.34.67" "sha256-tgiKSWgKebdPAsyuJTQoFGR9BSLfGMeTVbi1rnPnvfQ=";

  mypy-boto3-account = buildMypyBoto3Package "account" "1.34.0" "sha256-C2iAiA83tZ/7XRlccf1iddDfDNkuO2F0B5aOxKbHy2Q=";

  mypy-boto3-acm = buildMypyBoto3Package "acm" "1.34.0" "sha256-SvDBi8A9414Hxb8twcM/6Y2OoUz+/LbZZJ86lu/zmmo=";

  mypy-boto3-acm-pca = buildMypyBoto3Package "acm-pca" "1.34.28" "sha256-4x4M49/Ot/HDZrA30PCu0OzXn3636dxCO4exR3lJAUs=";

  mypy-boto3-alexaforbusiness = buildMypyBoto3Package "alexaforbusiness" "1.34.0" "sha256-wrMSoM3F0HgajmM9X6P+3i6mqD55TWGVv8eJ7XqNjrw=";

  mypy-boto3-amp = buildMypyBoto3Package "amp" "1.34.39" "sha256-XOousDfEQsZ9z48iH2wVHuUaIwoECwbkHvIAlV3+zu4=";

  mypy-boto3-amplify = buildMypyBoto3Package "amplify" "1.34.63" "sha256-alOtCCZwBcx6g3lm80AzI5aF8WbEABd44A0e6gfZ42o=";

  mypy-boto3-amplifybackend = buildMypyBoto3Package "amplifybackend" "1.34.0" "sha256-wP6fOHAUg4dvrlQ2rUNk/lgIr6JnpWu/0Tr2prTckOk=";

  mypy-boto3-amplifyuibuilder = buildMypyBoto3Package "amplifyuibuilder" "1.34.51" "sha256-umxA1d0jlSysBkUFP8VPRMwuwYxdsRz0yRH7lgr/Hhc=";

  mypy-boto3-apigateway = buildMypyBoto3Package "apigateway" "1.34.56" "sha256-WrFdsw1zAZg4TWRF1QzB/smDYbhTZt0JKxDpufShoss=";

  mypy-boto3-apigatewaymanagementapi = buildMypyBoto3Package "apigatewaymanagementapi" "1.34.0" "sha256-911Sd+7hnHpAhDFE2lDhl+b3Pewd5QWWOPdg+TcZ6VU=";

  mypy-boto3-apigatewayv2 = buildMypyBoto3Package "apigatewayv2" "1.34.0" "sha256-ydpZ3osSSMwTtGsnRn1SygX5d9Kq8jHwqdQDKcmKXTY=";

  mypy-boto3-appconfig = buildMypyBoto3Package "appconfig" "1.34.58" "sha256-f073cXEkDyzkPeOPclhS0O6ZVvEmYPkGPMXrAD8LkE4=";

  mypy-boto3-appconfigdata = buildMypyBoto3Package "appconfigdata" "1.34.24" "sha256-pSo1Qw6ZKN0XzERlCRmCtvJEOjgyd+a82t6Q3pPaU8Q=";

  mypy-boto3-appfabric = buildMypyBoto3Package "appfabric" "1.34.0" "sha256-wjvOtCvFrj+YPvyqvR8cKIvwvC6x15WeSX6PkNp4OWg=";

  mypy-boto3-appflow = buildMypyBoto3Package "appflow" "1.34.0" "sha256-XruMwzBrjV7QTHOcHKqszt75cHX+578wbTwFMwyXHzE=";

  mypy-boto3-appintegrations = buildMypyBoto3Package "appintegrations" "1.34.6" "sha256-iVaOlWOiCeocOJpcsxF0hlzKhGE3iq6Z7OifLWA3kkM=";

  mypy-boto3-application-autoscaling = buildMypyBoto3Package "application-autoscaling" "1.34.0" "sha256-xW+Rc6yjDBviNDBDB63ssg0aPZFytaVfrVlA32wY/D4=";

  mypy-boto3-application-insights = buildMypyBoto3Package "application-insights" "1.34.0" "sha256-p/yLWmIGBSkMcqbjMUjyTYiskfSRWW3hKvtqepJZtyM=";

  mypy-boto3-applicationcostprofiler = buildMypyBoto3Package "applicationcostprofiler" "1.34.0" "sha256-ToSRJScC8711J5fkZj/TNmUrpiBNwTplGjvpu1gidys=";

  mypy-boto3-appmesh = buildMypyBoto3Package "appmesh" "1.34.0" "sha256-AXJ4z/54qPQeHKbZF6Is4OXt9/gZNacmYnLwfxPcn+E=";

  mypy-boto3-apprunner = buildMypyBoto3Package "apprunner" "1.34.11" "sha256-p4txQ08e6jpYiJmjG/JIXyObXhTnlXB8S5QDtUPUFt0=";

  mypy-boto3-appstream = buildMypyBoto3Package "appstream" "1.34.5" "sha256-1m9YDw1fzoe4Y37yW6a1545SR2QGSrr5qbqYfXEax7o=";

  mypy-boto3-appsync = buildMypyBoto3Package "appsync" "1.34.49" "sha256-J2qTVaXhqsfdupN6eLgpyGTHkPRRC1TZGNP2PRKF0v0=";

  mypy-boto3-arc-zonal-shift = buildMypyBoto3Package "arc-zonal-shift" "1.34.0" "sha256-FhQaiu0Sc4HkkaRuhtgvUBMOgj80DbIBzZLEbZB41Cs=";

  mypy-boto3-athena = buildMypyBoto3Package "athena" "1.34.23" "sha256-PDvz2+2XcNi/nYkGjOeb8t1JbIN+SxSSifU6sDXoNyc=";

  mypy-boto3-auditmanager = buildMypyBoto3Package "auditmanager" "1.34.0" "sha256-22Xkl1A5wzKDpRQcr/lp7gQsDPtQjvjK3nBm5O2ZS+k=";

  mypy-boto3-autoscaling = buildMypyBoto3Package "autoscaling" "1.34.54" "sha256-MGACE7CeturY9BN6Gq3VAvz4TqeoQ/ASlSdbX9LLTbQ=";

  mypy-boto3-autoscaling-plans = buildMypyBoto3Package "autoscaling-plans" "1.34.0" "sha256-16siojcxNe5MuSZSRJXPAz2UudJozEEyCYUrsGNDAM8=";

  mypy-boto3-backup = buildMypyBoto3Package "backup" "1.34.64" "sha256-RvxhEmrOtkvagjaj8x2H7AAp+uK9qDIDe7T9p52rKRc=";

  mypy-boto3-backup-gateway = buildMypyBoto3Package "backup-gateway" "1.34.0" "sha256-nSIEEDKJfI852/WBQ7OuDPuVijEiMr1vhpkzODbhRRc=";

  mypy-boto3-backupstorage = buildMypyBoto3Package "backupstorage" "1.34.0" "sha256-Y8kjZ+ov8OsiJ8Sm1LlvP8YbgVc+AkLkbZIhOh4y7ZY=";

  mypy-boto3-batch = buildMypyBoto3Package "batch" "1.34.72" "sha256-ha5OZVVcO/+slxQOPIrd+D1Ehaw6YpGqCWofSgFj5JI=";

  mypy-boto3-billingconductor = buildMypyBoto3Package "billingconductor" "1.34.1" "sha256-uXxQkoe2u3idcYta9YFbjxoK8HsvUiRQSyYrYhVi1kU=";

  mypy-boto3-braket = buildMypyBoto3Package "braket" "1.34.39" "sha256-laMrKu9oN5a9yvB8lyhdjpq5hm1HGAFn3iJ0lReRpOI=";

  mypy-boto3-budgets = buildMypyBoto3Package "budgets" "1.34.0" "sha256-gs8JYnpFNOMWppBO2R3DO+c6RecQC0vzaox5DqXCKOA=";

  mypy-boto3-ce = buildMypyBoto3Package "ce" "1.34.71" "sha256-VfB823/q+ie97Bv5GXhsBaGxAuXSDbfFq2rO6TjThXY=";

  mypy-boto3-chime = buildMypyBoto3Package "chime" "1.34.0" "sha256-/IBkHJf4t1K/Ubdf/hUw5XToNBTCziMfTSdksxMwA2Q=";

  mypy-boto3-chime-sdk-identity = buildMypyBoto3Package "chime-sdk-identity" "1.34.0" "sha256-3gXUFr3+Tc5PgwsQuQY8D2J0SKGQJRXgQz7/XKYNr5k=";

  mypy-boto3-chime-sdk-media-pipelines = buildMypyBoto3Package "chime-sdk-media-pipelines" "1.34.0" "sha256-h5RD+anRtH0UQ5pFjhygN9oZDFdIRZMfGXSKlT2HuSY=";

  mypy-boto3-chime-sdk-meetings = buildMypyBoto3Package "chime-sdk-meetings" "1.34.4" "sha256-AmwzLd8iLGdmo1Ajv4IVrxwyf/UljG0I06um2S3PG+E=";

  mypy-boto3-chime-sdk-messaging = buildMypyBoto3Package "chime-sdk-messaging" "1.34.0" "sha256-8Pq48GBFKQRdmoAu9qxAR14xRSP8/roBrZHxzaTBB54=";

  mypy-boto3-chime-sdk-voice = buildMypyBoto3Package "chime-sdk-voice" "1.34.0" "sha256-9fQQgWFKeabSblJIhP6mN0CEnSixkz1r3mf/k6IL/BE=";

  mypy-boto3-cleanrooms = buildMypyBoto3Package "cleanrooms" "1.34.0" "sha256-gucAudT1eWqm/y/gynY7pgBXbs5n7fnzfeSlVQad7HI=";

  mypy-boto3-cloud9 = buildMypyBoto3Package "cloud9" "1.34.24" "sha256-fryD7UfO5cdFS7vMxmZaT9LW4nNSGTQCd3NyD60f9wA=";

  mypy-boto3-cloudcontrol = buildMypyBoto3Package "cloudcontrol" "1.34.0" "sha256-81M2llb46sviZ874/vHVaqOU1PvQs+Zdil8bxr1pEWM=";

  mypy-boto3-clouddirectory = buildMypyBoto3Package "clouddirectory" "1.34.0" "sha256-lWJQClNEhyq9CN8ThcHtVcEsowIp+V8RXh4rgHAclfM=";

  mypy-boto3-cloudformation = buildMypyBoto3Package "cloudformation" "1.34.66" "sha256-KV3bh48/S2FIm4O9S62Uk4LeuKR4/1rmbCLKP/urvpU=";

  mypy-boto3-cloudfront = buildMypyBoto3Package "cloudfront" "1.34.0" "sha256-3n/WEiQdcE253J+CFsskoYlNMXASdzkhPTWneSHDKoM=";

  mypy-boto3-cloudhsm = buildMypyBoto3Package "cloudhsm" "1.34.0" "sha256-Sd/YlKNm/1VRoJ+e+3YlOf4jKoewYVGM4FNYlST+9AY=";

  mypy-boto3-cloudhsmv2 = buildMypyBoto3Package "cloudhsmv2" "1.34.0" "sha256-TCKdRXnA2x3LBop9boixNmkPafTdIOY8sGaUSeA9Sic=";

  mypy-boto3-cloudsearch = buildMypyBoto3Package "cloudsearch" "1.34.0" "sha256-S1re04NWngrjlcLIPzP4D0I1cVqvt/Taku6CTTfvtMw=";

  mypy-boto3-cloudsearchdomain = buildMypyBoto3Package "cloudsearchdomain" "1.34.0" "sha256-jhhwFXH80aZjVqVMZulwoCvu3EmXj4BbJ3DQ6eJPS4E=";

  mypy-boto3-cloudtrail = buildMypyBoto3Package "cloudtrail" "1.34.59" "sha256-0gwq1zhZcLc8gVGo337AqqC39w8MJR6JK948No/yzVA=";

  mypy-boto3-cloudtrail-data = buildMypyBoto3Package "cloudtrail-data" "1.34.0" "sha256-ACiJrI+VTHr06i8PKgDY/K8houFUZQNS1lluouadCTQ=";

  mypy-boto3-cloudwatch = buildMypyBoto3Package "cloudwatch" "1.34.40" "sha256-M/C3Rzie5dcv6TGVl7ilI5WiT1uYFrCGL+7Fga+xSLw=";

  mypy-boto3-codeartifact = buildMypyBoto3Package "codeartifact" "1.34.68" "sha256-Ey0cmx0OxN1/VXIyvn0EOBP9qYIuc/XyFVZniHLaNEY=";

  mypy-boto3-codebuild = buildMypyBoto3Package "codebuild" "1.34.70" "sha256-lv69lhMKJHRnooVrmGinfDEi7eVEe7O12GNNo5uZQQc=";

  mypy-boto3-codecatalyst = buildMypyBoto3Package "codecatalyst" "1.34.0" "sha256-TsXVy8bx6kaj84PJiNNU+075Tx3WW0mrtZFOyLx9yT4=";

  mypy-boto3-codecommit = buildMypyBoto3Package "codecommit" "1.34.6" "sha256-wCw6e7yvMjM+A6jXfB2D4Z+i9s3e/F9Ih/VxD6iiwws=";

  mypy-boto3-codedeploy = buildMypyBoto3Package "codedeploy" "1.34.0" "sha256-Sxtcl/fO+A2/s/6O3VC1BPIJ3dDamshEEmKXqyg4fN8=";

  mypy-boto3-codeguru-reviewer = buildMypyBoto3Package "codeguru-reviewer" "1.34.0" "sha256-20W+LBYsQE/pNs94ZbVWNw0+2817gwfGKaJHCoiDsPM=";

  mypy-boto3-codeguru-security = buildMypyBoto3Package "codeguru-security" "1.34.0" "sha256-DTtYCgcy3LWGxuxqSAkeS9qoBq1YWwAWfZU2DD44BOY=";

  mypy-boto3-codeguruprofiler = buildMypyBoto3Package "codeguruprofiler" "1.34.0" "sha256-pAZL9m0SHRYiIrXzBf+IeEkQOXS4/6OJqoDI6og3N5s=";

  mypy-boto3-codepipeline = buildMypyBoto3Package "codepipeline" "1.34.43" "sha256-omGtS0+5qBDBxCcKoOM+dsraE22m129zYUJB2yRxBtQ=";

  mypy-boto3-codestar = buildMypyBoto3Package "codestar" "1.34.0" "sha256-BAueRLlYZGDiF6DtjxL24twLYYZqD3ErdJ73fsFoG1k=";

  mypy-boto3-codestar-connections = buildMypyBoto3Package "codestar-connections" "1.34.60" "sha256-WH/cN8BXG7c79gGR/0m3xvEPNdPAFRosInmO9DeAVdM=";

  mypy-boto3-codestar-notifications = buildMypyBoto3Package "codestar-notifications" "1.34.0" "sha256-JmXEpHbOhcO9F++G+ohXPuXoNILbcL9r5qyH4OooCtc=";

  mypy-boto3-cognito-identity = buildMypyBoto3Package "cognito-identity" "1.34.0" "sha256-6UlyNX0a1wG5FR/WHMZOwysikGffNCX6Fo1MYvFuFwM=";

  mypy-boto3-cognito-idp = buildMypyBoto3Package "cognito-idp" "1.34.59" "sha256-kZpXb5MzK4IceWnNs9tWWLhQnysfWGuOLf00J4/ypvw=";

  mypy-boto3-cognito-sync = buildMypyBoto3Package "cognito-sync" "1.34.0" "sha256-JTkmpEHwKN5IyoGVs4beVAEOr1fZPxBoYjzNBgjTEY0=";

  mypy-boto3-comprehend = buildMypyBoto3Package "comprehend" "1.34.30" "sha256-G7mSJWcr0ntPX6WoaeTWPw/uB32yn6xXPyyQvDVfa8s=";

  mypy-boto3-comprehendmedical = buildMypyBoto3Package "comprehendmedical" "1.34.0" "sha256-4KzL56xU474te8tW5xVZo6D5Pwe3GLRQbQfX8CXTz9g=";

  mypy-boto3-compute-optimizer = buildMypyBoto3Package "compute-optimizer" "1.34.0" "sha256-k/4Ixaf9n4J8Y5ELjuMZ2dn7DgKftmwQZfdHhYDMc6w=";

  mypy-boto3-config = buildMypyBoto3Package "config" "1.34.45" "sha256-LN1CcIOj9cgzSNCvnUVwLRNPXlitHAlt+5jj6wu6i8E=";

  mypy-boto3-connect = buildMypyBoto3Package "connect" "1.34.67" "sha256-kWjC/FacCsC0xevx2dOs67UxaKG1WM3xMahcO3CqZL8=";

  mypy-boto3-connect-contact-lens = buildMypyBoto3Package "connect-contact-lens" "1.34.0" "sha256-Wx9vcjlgXdWZ2qP3Y/hTY2LAeTd+hyyV5JSIuKQ5I5k=";

  mypy-boto3-connectcampaigns = buildMypyBoto3Package "connectcampaigns" "1.34.16" "sha256-CR1FuVJgYODKEhDmmwcWrjPyZm7HsFRlzq3HlnKe81E=";

  mypy-boto3-connectcases = buildMypyBoto3Package "connectcases" "1.34.24" "sha256-a3P7wPx2FQ3V5T68B4fYzuq2juiqs7R8K5WSbyWu5ug=";

  mypy-boto3-connectparticipant = buildMypyBoto3Package "connectparticipant" "1.34.44" "sha256-kP4ovwHfJoeRjSyfeL0M1U70aJoApMUUWOLFRpt6H+w=";

  mypy-boto3-controltower = buildMypyBoto3Package "controltower" "1.34.42" "sha256-HwVES0lu75XkBPE7WQMSP2tOSogAqO3yr+cIeWaw9Is=";

  mypy-boto3-cur = buildMypyBoto3Package "cur" "1.34.0" "sha256-vwMILmIX7uzAGXdl1Z5mxVMJlgZCtA3Svp8mFmoZ6tQ=";

  mypy-boto3-customer-profiles = buildMypyBoto3Package "customer-profiles" "1.34.0" "sha256-LxonO6G0Qa8j6VORcAwvR9j+w879Di5pqTzlicC9Dp8=";

  mypy-boto3-databrew = buildMypyBoto3Package "databrew" "1.34.0" "sha256-DP1Cuyogrs/K6qM7fnbHWSTPcpjoy1m0XEsq1ONbhxM=";

  mypy-boto3-dataexchange = buildMypyBoto3Package "dataexchange" "1.34.0" "sha256-gLJ6AJQLKSiGcwWEgDwipg0D1NqYwNFiXwAUGwCJ2+0=";

  mypy-boto3-datapipeline = buildMypyBoto3Package "datapipeline" "1.34.0" "sha256-Amn6pdW5i8+yBzuSRAmj0EnTYEGjzguQxaoLmhFFXck=";

  mypy-boto3-datasync = buildMypyBoto3Package "datasync" "1.34.37" "sha256-uVZsnbghzbjDAuR+d6l7EET6S9fvx2NYGEllCPLtIXQ=";

  mypy-boto3-dax = buildMypyBoto3Package "dax" "1.34.0" "sha256-DH5kqV+C4vbZ8fbvAtR93jd5YB22hkYe/xgOF4oru1Y=";

  mypy-boto3-detective = buildMypyBoto3Package "detective" "1.34.43" "sha256-VevmUTgN0UKhWAtGfSbQoqAhgv19XiOBBoNNsHfHezg=";

  mypy-boto3-devicefarm = buildMypyBoto3Package "devicefarm" "1.34.0" "sha256-X0D4Am4GUDFl703FmdrPcHXihFdzuch/eQBofDTameQ=";

  mypy-boto3-devops-guru = buildMypyBoto3Package "devops-guru" "1.34.0" "sha256-IxSTAjcJcGySV1Zzlxal23nZz7m1eaCDa8UX41+9l5o=";

  mypy-boto3-directconnect = buildMypyBoto3Package "directconnect" "1.34.0" "sha256-H3xxqWZwjjzf7gFwsEfAcQmFfm3ZxNOBge0yFsfQpLM=";

  mypy-boto3-discovery = buildMypyBoto3Package "discovery" "1.34.0" "sha256-QT3KX4bHVigaeOxMCBBtLR3lbTLOQAl1JDnMzN7gt9s=";

  mypy-boto3-dlm = buildMypyBoto3Package "dlm" "1.34.0" "sha256-uBcxQvYlWvhoVdWThvaETCKCmju0xtIFRcE8Eon6ovI=";

  mypy-boto3-dms = buildMypyBoto3Package "dms" "1.34.0" "sha256-xGGMtqja+ipLpWRMXO1VzxHqjlaZDZ31p634u5kmyNs=";

  mypy-boto3-docdb = buildMypyBoto3Package "docdb" "1.34.13" "sha256-oh6mrgHSr64TK/iYypOYZtqEEFtNfaIWpqj6sFatP18=";

  mypy-boto3-docdb-elastic = buildMypyBoto3Package "docdb-elastic" "1.34.53" "sha256-sNoS7ujT0rMi4WAFXwIfwkoGP3c88+l6cW7eliHheJ4=";

  mypy-boto3-drs = buildMypyBoto3Package "drs" "1.34.50" "sha256-UWqnQAyxBnQjGYofZMOD3nhnqxTMh2U7/FNtMId1isk=";

  mypy-boto3-ds = buildMypyBoto3Package "ds" "1.34.0" "sha256-qVtMpsnVLF2rN4WaEhrqlTvWvW28RcHIBjsZYwmYapc=";

  mypy-boto3-dynamodb = buildMypyBoto3Package "dynamodb" "1.34.67" "sha256-CUR+8+pr3+C+TjLKIyg4IFczQdNAvqMGXe0hU8xZPSI=";

  mypy-boto3-dynamodbstreams = buildMypyBoto3Package "dynamodbstreams" "1.34.0" "sha256-Zx5cJE+fU9NcvK5rLR966AGIKUvfIwdpLaWWdLmuDzc=";

  mypy-boto3-ebs = buildMypyBoto3Package "ebs" "1.34.0" "sha256-xIrrXOayZed+Jcn4CFXXNgKz/G+RdiuwA04wq+Ry/fs=";

  mypy-boto3-ec2 = buildMypyBoto3Package "ec2" "1.34.71" "sha256-hjEJNB8/m1yE9f0yxoKZeVySRfCun1NGmL8UeqP8AXs=";

  mypy-boto3-ec2-instance-connect = buildMypyBoto3Package "ec2-instance-connect" "1.34.63" "sha256-kExmGXEJ5jrvOewmWx7AjVb3boD5GU0cEUp/2PQhzlw=";

  mypy-boto3-ecr = buildMypyBoto3Package "ecr" "1.34.0" "sha256-uD+wMR6WikLUyoIbAGwY1KPj42S4zr7nWOpPqXxaw0U=";

  mypy-boto3-ecr-public = buildMypyBoto3Package "ecr-public" "1.34.0" "sha256-38ZiRVPr9L+KUF6oL23xsIiKMW0pT/nIngFkhSS3z2Y=";

  mypy-boto3-ecs = buildMypyBoto3Package "ecs" "1.34.71" "sha256-Ka2nMhArorYcIx+MoLN7bIbKl4ptNER6uC9FdLWZBfI=";

  mypy-boto3-efs = buildMypyBoto3Package "efs" "1.34.0" "sha256-VAK7mfnPBPDC8Azm6Bxl86E8CkeArTmfgqYkIcSblYA=";

  mypy-boto3-eks = buildMypyBoto3Package "eks" "1.34.53" "sha256-bmd/gv3krZZSeQDCYca/AFHkSBL4PTvx3ZEjItQ43QQ=";

  mypy-boto3-elastic-inference = buildMypyBoto3Package "elastic-inference" "1.34.0" "sha256-gbWKw0zDQf3qBlp1KeO7MX1j/GqRUpFAxLG0BKFrHBk=";

  mypy-boto3-elasticache = buildMypyBoto3Package "elasticache" "1.34.72" "sha256-yZd2KB7wIw23PybblyIlCo/5IEFYxAUfbLD2J91eOzw=";

  mypy-boto3-elasticbeanstalk = buildMypyBoto3Package "elasticbeanstalk" "1.34.0" "sha256-ftVFUwY81mg/9zJ4xxVjhXF1HgKpzj1koIS32cMKRLw=";

  mypy-boto3-elastictranscoder = buildMypyBoto3Package "elastictranscoder" "1.34.0" "sha256-tC+9Ks0DDC3zWBd9C964X8TFoL6kblWxG0jUQrzdID0=";

  mypy-boto3-elb = buildMypyBoto3Package "elb" "1.34.0" "sha256-5Eh5D872pVDd7Q+DDh3zpGMVgS8fUJsV+63H1fet73s=";

  mypy-boto3-elbv2 = buildMypyBoto3Package "elbv2" "1.34.63" "sha256-snXMLMHLEpJjfX1GJp6FfYgIjkS8vkbf/hESBdhxIfk=";

  mypy-boto3-emr = buildMypyBoto3Package "emr" "1.34.44" "sha256-zM1VpAaBSxqdZiSrNiaAKfvliNRXMLEmvFvXcFmkZO0=";

  mypy-boto3-emr-containers = buildMypyBoto3Package "emr-containers" "1.34.70" "sha256-uZADsQWfrkoVrQZosfqogcKERWsykIqdk+tJpgmcai4=";

  mypy-boto3-emr-serverless = buildMypyBoto3Package "emr-serverless" "1.34.0" "sha256-YgccYi2+XhKiPGCMimrCooYPRV+iRuA1h120UdqJKUc=";

  mypy-boto3-entityresolution = buildMypyBoto3Package "entityresolution" "1.34.0" "sha256-qfRZtRaxysW+Ev16gnj48CePZzLBWrXmrq3tEGtfNbM=";

  mypy-boto3-es = buildMypyBoto3Package "es" "1.34.36" "sha256-uVLB1fjZRhlqJ/isKl5TDORmIN4ffKKqzyGZcEffa5g=";

  mypy-boto3-events = buildMypyBoto3Package "events" "1.34.17" "sha256-L/78a975mFWw5xBH4et01j4Ba9/aGb5NUK7d/bPtsJU=";

  mypy-boto3-evidently = buildMypyBoto3Package "evidently" "1.34.0" "sha256-MkBB5iTYJYg2cWFYHR3Qu7TcsDglLPEw0MnoHqij6+A=";

  mypy-boto3-finspace = buildMypyBoto3Package "finspace" "1.34.71" "sha256-bgPwDXqu73DjQCADmjTig6kLNOWvQ39flwhyYAbTai4=";

  mypy-boto3-finspace-data = buildMypyBoto3Package "finspace-data" "1.34.0" "sha256-8mND5BbdKY5srFwdpxSyfCUTIP4fa9hztP4daUJOB8k=";

  mypy-boto3-firehose = buildMypyBoto3Package "firehose" "1.34.69" "sha256-GCMH/XA9ETSuo39OnlvyhfHDKylsTeLO1R1+7tl2S/E=";

  mypy-boto3-fis = buildMypyBoto3Package "fis" "1.34.63" "sha256-TJnzgQGDcybpVqg+p7Tuvw/RoY79cQPPChyHWlMxhiY=";

  mypy-boto3-fms = buildMypyBoto3Package "fms" "1.34.0" "sha256-tzaSecIXzkC+Zr5MGpU7GaoiGHGsywEglZ8+Ja0XDDo=";

  mypy-boto3-forecast = buildMypyBoto3Package "forecast" "1.34.0" "sha256-DuNZe9Q7HuEeJYuBqo7JRBTJgclyUpU9fJ62SCGYpLQ=";

  mypy-boto3-forecastquery = buildMypyBoto3Package "forecastquery" "1.34.0" "sha256-IEKWQbwRDHiT/n5dSXXtLDqRVK12+EiSg9J+dGXfqx8=";

  mypy-boto3-frauddetector = buildMypyBoto3Package "frauddetector" "1.34.0" "sha256-EjiFEFpLKN0NmrNY43CFhQZHN+COTwRXx513X6X7vlE=";

  mypy-boto3-fsx = buildMypyBoto3Package "fsx" "1.34.55" "sha256-XsIX4C8sF1m8jGbwrDWGoV7onHA9tRlI5Dki43bf9FM=";

  mypy-boto3-gamelift = buildMypyBoto3Package "gamelift" "1.34.1" "sha256-EUdVrcriXRUqjcyKzyuoIdDTxMSAdyKcnbJ96s/Y8Uc=";

  mypy-boto3-gamesparks = buildMypyBoto3Package "gamesparks" "1.28.36" "sha256-6lQXNJ55FYvkFA14rgJGhRMjBHA3YrOybnsKNecX7So=";

  mypy-boto3-glacier = buildMypyBoto3Package "glacier" "1.34.0" "sha256-j8LUD8EjjRL1av7UEXBqNPEARaSFgstaioGJtbel4oM=";

  mypy-boto3-globalaccelerator = buildMypyBoto3Package "globalaccelerator" "1.34.70" "sha256-7Su+rgV6KD9I4j630Qybufwn39rp/8tYQ2ldEe2Untc=";

  mypy-boto3-glue = buildMypyBoto3Package "glue" "1.34.35" "sha256-+Kvk8uB9KZp7mw3sMAM6mHdBTnkO5J8nSVClttndMDY=";

  mypy-boto3-grafana = buildMypyBoto3Package "grafana" "1.34.58" "sha256-dr+fCDf0DcWGxPPLMnzqrOCRMfoLhznyv6n679fFU/0=";

  mypy-boto3-greengrass = buildMypyBoto3Package "greengrass" "1.34.0" "sha256-ZU/xVWGlMngX0JiAhy9NEFDoXS4fsZvmLAkWqv2pocQ=";

  mypy-boto3-greengrassv2 = buildMypyBoto3Package "greengrassv2" "1.34.0" "sha256-O3g6JHvnfvgKL0ax9R6IWgxdEoALaycfsBAhvWdERH0=";

  mypy-boto3-groundstation = buildMypyBoto3Package "groundstation" "1.34.0" "sha256-CR3w42iyXmyGMzjCM7M1LKqsIROMjXxxGM8coSTtJ3o=";

  mypy-boto3-guardduty = buildMypyBoto3Package "guardduty" "1.34.59" "sha256-Q5itLyYcSK7tzlYjT4Dgdcm4bE2Dr+bl5kfHqV4D9Pg=";

  mypy-boto3-health = buildMypyBoto3Package "health" "1.34.0" "sha256-st3ygy9yZbAbh1ZWnT8XDZTBz1qWhRWXCEfr5ILQHpo=";

  mypy-boto3-healthlake = buildMypyBoto3Package "healthlake" "1.34.43" "sha256-Xci7f0/o60v1TAazFC34GjpzOBQlD+SvAMCF4xM3ymI=";

  mypy-boto3-honeycode = buildMypyBoto3Package "honeycode" "1.34.0" "sha256-HNp/STFuMLoO4qyL0iaYeiPpnMV3uzNBNFUDgzrHt9s=";

  mypy-boto3-iam = buildMypyBoto3Package "iam" "1.34.8" "sha256-b69oz4ABgpJGh7ZxGz+a+o2UCtmT8lmjuR5V6CiS1kE=";

  mypy-boto3-identitystore = buildMypyBoto3Package "identitystore" "1.34.0" "sha256-OdJsMjraTe4qhpblBOuwr++4QfiMXtaaMHDAEOTBII4=";

  mypy-boto3-imagebuilder = buildMypyBoto3Package "imagebuilder" "1.34.57" "sha256-r11JVMvO/IL1d2+fGZoc4nt1JnyUXir38a8i7IsZmLQ=";

  mypy-boto3-importexport = buildMypyBoto3Package "importexport" "1.34.0" "sha256-GnIzCaCuRLPdvaAmmID62uY/te1Lx5DFGin2zJuDdAM=";

  mypy-boto3-inspector = buildMypyBoto3Package "inspector" "1.34.0" "sha256-85aAE1+azKZ9sFYxLOpVR4SkqrnfFQ1gXgGpzOBK1PE=";

  mypy-boto3-inspector2 = buildMypyBoto3Package "inspector2" "1.34.29" "sha256-ZMdNVgKXQnEHyK4tV/XegvFX7xdk5A1AiSfpTKWCtcY=";

  mypy-boto3-internetmonitor = buildMypyBoto3Package "internetmonitor" "1.34.48" "sha256-tJ5Hu8ojUahG1YbNHgwDjYWqbSPCZEUyYM/dOObmArg=";

  mypy-boto3-iot = buildMypyBoto3Package "iot" "1.34.52" "sha256-YWGotOPKljY4B0JL1I+axk4MJZIk84rVxoZu9tzBGss=";

  mypy-boto3-iot-data = buildMypyBoto3Package "iot-data" "1.34.0" "sha256-N6UoHopsT3FM7bU01eWuqRSyyyaLBekkM+hsOU1byIM=";

  mypy-boto3-iot-jobs-data = buildMypyBoto3Package "iot-jobs-data" "1.34.0" "sha256-ceqk+Gt+IcIVuLp/LMsrjnUXrPt+SY+mI8G3hKdE7TY=";

  mypy-boto3-iot-roborunner = buildMypyBoto3Package "iot-roborunner" "1.34.0" "sha256-TfhJHtE2zlEr80SGbxAZfK2+M/ad596fdwex+4GhBf8=";

  mypy-boto3-iot1click-devices = buildMypyBoto3Package "iot1click-devices" "1.34.0" "sha256-Zpv/kw541LoC3Z58eKGe7sK5qioWMGswQS0O+jvNZgY=";

  mypy-boto3-iot1click-projects = buildMypyBoto3Package "iot1click-projects" "1.34.0" "sha256-QZ06B5UQSuDPUaXqZYPjawSEjIQjBwP7d5/obpvNivI=";

  mypy-boto3-iotanalytics = buildMypyBoto3Package "iotanalytics" "1.34.0" "sha256-aDlptQYJQ71WWYsgv+bFRoD2fmeGgiUl1Fv/oOAQJEM=";

  mypy-boto3-iotdeviceadvisor = buildMypyBoto3Package "iotdeviceadvisor" "1.34.0" "sha256-DBI4dJXxprfHO3ipLIVb5Ii5NK7qWJRuWjzVfHTnqO4=";

  mypy-boto3-iotevents = buildMypyBoto3Package "iotevents" "1.34.47" "sha256-ppsjLI2yY9+6SmAh1mfVBuZz+gHNNZS6eKDr3fHHmJM=";

  mypy-boto3-iotevents-data = buildMypyBoto3Package "iotevents-data" "1.34.0" "sha256-K7yAnxjpJfSh6bWnmcdySkCQhhVFt42zU6REiy3zKrk=";

  mypy-boto3-iotfleethub = buildMypyBoto3Package "iotfleethub" "1.34.0" "sha256-wNm6OJUgAhvrXhtGaty19Tyva+nvonDOHsj9RT37FbY=";

  mypy-boto3-iotfleetwise = buildMypyBoto3Package "iotfleetwise" "1.34.20" "sha256-Pe5Pw19H2y6koJxajW46oazxoFL5UHSOQHgXnhfIQJk=";

  mypy-boto3-iotsecuretunneling = buildMypyBoto3Package "iotsecuretunneling" "1.34.0" "sha256-E8658X3yWpIcRKDTtnacjuAAWqr/qnmYXFRJ/7uyKm8=";

  mypy-boto3-iotsitewise = buildMypyBoto3Package "iotsitewise" "1.34.0" "sha256-/WDIf5WRUYbuhkzjXrX1t3BvHd7ZXBem2o8TysFWYQw=";

  mypy-boto3-iotthingsgraph = buildMypyBoto3Package "iotthingsgraph" "1.34.0" "sha256-8D0jqOuusz6SLCr+eKAZpTr9dvdonIc7+UYyXDzVzYQ=";

  mypy-boto3-iottwinmaker = buildMypyBoto3Package "iottwinmaker" "1.34.0" "sha256-K5LEh8wdXvftxGstThSBN73K+1FUVlE40JxvjWv6GMA=";

  mypy-boto3-iotwireless = buildMypyBoto3Package "iotwireless" "1.34.0" "sha256-g2Ab6AQ0fvmEuSqAHlvAPe3TYSz/Nai1U8srjT0QWHw=";

  mypy-boto3-ivs = buildMypyBoto3Package "ivs" "1.34.45" "sha256-Ilrtk6ZF1p3GNuZrtiEiNXi3bHI3MYNr6bDpJ8sf4Fg=";

  mypy-boto3-ivs-realtime = buildMypyBoto3Package "ivs-realtime" "1.34.62" "sha256-/8P/S2xdYub8/tC0yaUbUfcxfDKpDnfAvmqneXFcAOo=";

  mypy-boto3-ivschat = buildMypyBoto3Package "ivschat" "1.34.0" "sha256-eNwL7uUI7x30KJwNO5U/0XSV1O4YZYu/zYvGQgz7p+8=";

  mypy-boto3-kafka = buildMypyBoto3Package "kafka" "1.34.61" "sha256-nXd3Qi8IZsQN595vnsMLSn6pfZU70yPb6Ebhv4SijfE=";

  mypy-boto3-kafkaconnect = buildMypyBoto3Package "kafkaconnect" "1.34.50" "sha256-frPPAQeFyO92uMqqzBcSC3MVK4V4hbdO9tx4awAKAUU=";

  mypy-boto3-kendra = buildMypyBoto3Package "kendra" "1.34.69" "sha256-OKUSsCfv2X9ad5XUSwm0KRwW++qb+AVtvCOurlRM/bo=";

  mypy-boto3-kendra-ranking = buildMypyBoto3Package "kendra-ranking" "1.34.0" "sha256-hbemz5ECtfP3oi645lZT7CCx31yg8MNqbAD32Am6l1U=";

  mypy-boto3-keyspaces = buildMypyBoto3Package "keyspaces" "1.34.45" "sha256-Ucmttfi8oQIPpdfr3KPvrX1Tj3zbYxHGoYH0JNYX5UM=";

  mypy-boto3-kinesis = buildMypyBoto3Package "kinesis" "1.34.0" "sha256-9ATnW63Vl36fCXQbdpuIiIVL3UEcYxNEaGq4ie/ph0E=";

  mypy-boto3-kinesis-video-archived-media = buildMypyBoto3Package "kinesis-video-archived-media" "1.34.10" "sha256-B66x9erx5SlnDmTBpf4izGckF4GysChy+VRXy9tWSf4=";

  mypy-boto3-kinesis-video-media = buildMypyBoto3Package "kinesis-video-media" "1.34.0" "sha256-YgkG14UzymthRLg4cga80ZDK9cxZzFBTISmnfTPt8nM=";

  mypy-boto3-kinesis-video-signaling = buildMypyBoto3Package "kinesis-video-signaling" "1.34.0" "sha256-aNFuruM0kQNhp+wEJr+Bo9MzLieG6a8xzbrHGAovgw8=";

  mypy-boto3-kinesis-video-webrtc-storage = buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.34.0" "sha256-Oi6r/AxePB0znUPg3fb22qZLDS4Cola5Vvs38Railnc=";

  mypy-boto3-kinesisanalytics = buildMypyBoto3Package "kinesisanalytics" "1.34.0" "sha256-eEoSmwMTa/hsbKbuKuzAZv4jHljGKq3b5Rw7K2Pgc50=";

  mypy-boto3-kinesisanalyticsv2 = buildMypyBoto3Package "kinesisanalyticsv2" "1.34.64" "sha256-7sJyrWtBcbrWlCjR7pLdBLgW7sXcRazDPBW+OGwh4Xg=";

  mypy-boto3-kinesisvideo = buildMypyBoto3Package "kinesisvideo" "1.34.48" "sha256-uYSkwOuYKF3B+sj5IWbDL789Xue2yNY9g14j/2b6k6w=";

  mypy-boto3-kms = buildMypyBoto3Package "kms" "1.34.65" "sha256-jot13mfxhgvayvQkMxnDvjdwkpGLkwsC2eeAQpMW0II=";

  mypy-boto3-lakeformation = buildMypyBoto3Package "lakeformation" "1.34.7" "sha256-/IPOF44ohg59XX+lmMbx8WsaHFpBaMH440Wm5jgrKD4=";

  mypy-boto3-lambda = buildMypyBoto3Package "lambda" "1.34.58" "sha256-kDgix0vRs0dI6y1y6rDxMvvDs5LIBBqo/k2VUqRLDGU=";

  mypy-boto3-lex-models = buildMypyBoto3Package "lex-models" "1.34.0" "sha256-LkD3CCjJYGwlSYRP0meJUCEdVSGGdSRrL9uBtimX4GU=";

  mypy-boto3-lex-runtime = buildMypyBoto3Package "lex-runtime" "1.34.0" "sha256-oFUSsfT7RXHRAVUUk014lqPylPa+TZuyNuvHRixIxt8=";

  mypy-boto3-lexv2-models = buildMypyBoto3Package "lexv2-models" "1.34.53" "sha256-xeuLY+rMoqtJc75pf2A/DYcsG86qqsIDO225QIwjlDw=";

  mypy-boto3-lexv2-runtime = buildMypyBoto3Package "lexv2-runtime" "1.34.0" "sha256-V1OkUcwFYp8TVS2ASFjARJUrIKAx/9zcfQbQMngU5Uc=";

  mypy-boto3-license-manager = buildMypyBoto3Package "license-manager" "1.34.0" "sha256-93G6q8UIQ/6VtreLOSTQm99tFvsW917t0UgfKkp0kqs=";

  mypy-boto3-license-manager-linux-subscriptions = buildMypyBoto3Package "license-manager-linux-subscriptions" "1.34.0" "sha256-yHvpZZn49SjTn/DLjSRhzGc2vg0IVv5GCeOFnhtScKA=";

  mypy-boto3-license-manager-user-subscriptions = buildMypyBoto3Package "license-manager-user-subscriptions" "1.34.0" "sha256-PR+u+i5zSHFTN6+GuOcWBcON1E2SNABbPavByXz3unE=";

  mypy-boto3-lightsail = buildMypyBoto3Package "lightsail" "1.34.41" "sha256-Y7Zg/eorUegxh+Br+ULbedzGskkHKR2opnEEDpfBVk0=";

  mypy-boto3-location = buildMypyBoto3Package "location" "1.34.18" "sha256-rsjIGenXgdEdgxvilA3IKJkYkpDDQNDfjDQRoj/mxSU=";

  mypy-boto3-logs = buildMypyBoto3Package "logs" "1.34.66" "sha256-z1+sSAHdkvBQB/sbRET/mCWFRNHyHmTpIo40GIBG+EE=";

  mypy-boto3-lookoutequipment = buildMypyBoto3Package "lookoutequipment" "1.34.47" "sha256-M7NaoRHxlH5/zkuMnOlrco2BCPXErv/N7TAVwv2oZuA=";

  mypy-boto3-lookoutmetrics = buildMypyBoto3Package "lookoutmetrics" "1.34.0" "sha256-2SRBUd8fZ7i2GbDgBWJcYS0Fbr/U65UmrLbHx57IZ5A=";

  mypy-boto3-lookoutvision = buildMypyBoto3Package "lookoutvision" "1.34.0" "sha256-+zl9JmGel0rkmGeYaHMlBIfPQfHdJQOk+sG/nuHnzD0=";

  mypy-boto3-m2 = buildMypyBoto3Package "m2" "1.34.0" "sha256-ZF3ZViV0pN64OEc8aHuCRR0lnVyHOiTRfqVQGCmMMKE=";

  mypy-boto3-machinelearning = buildMypyBoto3Package "machinelearning" "1.34.0" "sha256-DeiBu3PQMageEUlVdjH/1uELsPwo4IVhYzDlJFBohKg=";

  mypy-boto3-macie = buildMypyBoto3Package "macie" "1.29.0" "sha256-lFOPbIBrGuv9W83fsyzyI5fyOleXf4j3sCh9IM0gaQ4=";

  mypy-boto3-macie2 = buildMypyBoto3Package "macie2" "1.34.20" "sha256-erqa/ptOBMd8x+N1A6ibSULfBH75gEWsKDd/jhc/9tg=";

  mypy-boto3-managedblockchain = buildMypyBoto3Package "managedblockchain" "1.34.0" "sha256-gUPuS8/ygIdsfCx6S1zpxP936Ah0o5BT4TaDiEW4wPQ=";

  mypy-boto3-managedblockchain-query = buildMypyBoto3Package "managedblockchain-query" "1.34.67" "sha256-c2BoAKpgurKaNOTkl3cqc3X1CiaQVfQL5kvQV3/WLww=";

  mypy-boto3-marketplace-catalog = buildMypyBoto3Package "marketplace-catalog" "1.34.41" "sha256-SZqNZO/36iGuf0jqNIZrbD1BOE7p6xMWhs5Y5VkUl8c=";

  mypy-boto3-marketplace-entitlement = buildMypyBoto3Package "marketplace-entitlement" "1.34.0" "sha256-yGaeDZLEmp/Nap++wI6GgQvVW3HxQFcM+ipk7RAuG4g=";

  mypy-boto3-marketplacecommerceanalytics = buildMypyBoto3Package "marketplacecommerceanalytics" "1.34.0" "sha256-Gzmd4GQnM2sRrL4/FE9kI0R9ItKJ5xdaC/cCGqQ0XAY=";

  mypy-boto3-mediaconnect = buildMypyBoto3Package "mediaconnect" "1.34.7" "sha256-A8Sal8qNijZ/PdwLLC3mGAt8btMGOHXzOAOVFn+JDtU=";

  mypy-boto3-mediaconvert = buildMypyBoto3Package "mediaconvert" "1.34.33" "sha256-7OwfjcWDE1AHvpyOu3fE5YBwjQscpa+VnE7eylk1unA=";

  mypy-boto3-medialive = buildMypyBoto3Package "medialive" "1.34.70" "sha256-WMBmgEckAoWpwe/YMJsVRZnbkT8dbr8F1S3AW1PRF+4=";

  mypy-boto3-mediapackage = buildMypyBoto3Package "mediapackage" "1.34.0" "sha256-4DJ2zVk0satmVn+TZdDExx/+ClJpc1bdmbvl72Joe5U=";

  mypy-boto3-mediapackage-vod = buildMypyBoto3Package "mediapackage-vod" "1.34.0" "sha256-XwGc3+WD8o/MUfcBocl52TPK/RhiCjEb2qDqcuYwB+g=";

  mypy-boto3-mediapackagev2 = buildMypyBoto3Package "mediapackagev2" "1.34.60" "sha256-tm54AEKAAuhp8+KeoW/yesl0M8utg7iIbkOpLyotpa8=";

  mypy-boto3-mediastore = buildMypyBoto3Package "mediastore" "1.34.0" "sha256-v2G2wDXGJwMalYnHTRGvdRTUv41bm8adIOj9tgQV0ys=";

  mypy-boto3-mediastore-data = buildMypyBoto3Package "mediastore-data" "1.34.0" "sha256-bYlKkBh7Kq4PsToHQ4+K5B3h8+IwyS+7ngEJ5AALBus=";

  mypy-boto3-mediatailor = buildMypyBoto3Package "mediatailor" "1.34.65" "sha256-JJDQuyACp+y5PntLhMZ2rIb1wR/IW0PPPqS8HB54mNk=";

  mypy-boto3-medical-imaging = buildMypyBoto3Package "medical-imaging" "1.34.0" "sha256-3lAWDWzf1MjTDh0+HDnewq0Yo3bUuhSGSSKJvJf6k8g=";

  mypy-boto3-memorydb = buildMypyBoto3Package "memorydb" "1.34.0" "sha256-bq2FQsYZ/7xi2o4cdacva510FjDRfbNRO2IrA0oxtAg=";

  mypy-boto3-meteringmarketplace = buildMypyBoto3Package "meteringmarketplace" "1.34.0" "sha256-1un4l+XXDAen0NS1lQ2e1XOyUaoOjt+n8AU0VvGlTP0=";

  mypy-boto3-mgh = buildMypyBoto3Package "mgh" "1.34.0" "sha256-tyA+ywgjdRkIU2vbZwCsQfWIYctw/kLjIGTEAZuf8oU=";

  mypy-boto3-mgn = buildMypyBoto3Package "mgn" "1.34.0" "sha256-BKzXdrkbnMw4m53xIRBSLta7wxeQpOEMgK6Yj9hmLf0=";

  mypy-boto3-migration-hub-refactor-spaces = buildMypyBoto3Package "migration-hub-refactor-spaces" "1.34.0" "sha256-T37s/ubwuU1zsKk8DmTFum6Ml3+WNZCJ+q8T6F75iUY=";

  mypy-boto3-migrationhub-config = buildMypyBoto3Package "migrationhub-config" "1.34.0" "sha256-feqiUjFrwYaAyRh1MZ96VILeEa/WBzUytsnRxXZMxoQ=";

  mypy-boto3-migrationhuborchestrator = buildMypyBoto3Package "migrationhuborchestrator" "1.34.53" "sha256-kreU8blZ61EaKmKJpZ17iS6xFUig5FrMnOs5/1JTn4s=";

  mypy-boto3-migrationhubstrategy = buildMypyBoto3Package "migrationhubstrategy" "1.34.0" "sha256-N/NcnXF14SAs9F1ZwUYxc/5kp7iUWIFJisUfZxMStLU=";

  mypy-boto3-mobile = buildMypyBoto3Package "mobile" "1.34.0" "sha256-fzP70K6S7KPi6GnEj92shU+Dr07ieqDkmrAUEBxMVdI=";

  mypy-boto3-mq = buildMypyBoto3Package "mq" "1.34.0" "sha256-yua6b3bSoXnJjAvsDHa+aE6DebBjQkAKdsy+nM7TcTE=";

  mypy-boto3-mturk = buildMypyBoto3Package "mturk" "1.34.0" "sha256-qhyVd+9KIaL4hxjjDnw7qdyJdcT6ApCxhoTggOVDr80=";

  mypy-boto3-mwaa = buildMypyBoto3Package "mwaa" "1.34.57" "sha256-D0W/03zhllRLYGyXQ/XvMBlcsKuEb2MPr0hmyUVy5xc=";

  mypy-boto3-neptune = buildMypyBoto3Package "neptune" "1.34.0" "sha256-oMS6e1cPfOZhh+obhOZTMjmwScEzwCBtvmjtpPIjltA=";

  mypy-boto3-neptunedata = buildMypyBoto3Package "neptunedata" "1.34.0" "sha256-ZKTaSuLNtxUyP1mW2q8RF8jvXKSfEyHZfJp77xRqbZc=";

  mypy-boto3-network-firewall = buildMypyBoto3Package "network-firewall" "1.34.0" "sha256-I861Vg32yZJjg9/6q2KmFhysk/ysLZAg2ukNlWMEpuY=";

  mypy-boto3-networkmanager = buildMypyBoto3Package "networkmanager" "1.34.0" "sha256-vubUkzOk3bBuXVgHzMhYszMOhUqhBoupc7COdP0nneA=";

  mypy-boto3-nimble = buildMypyBoto3Package "nimble" "1.34.0" "sha256-i0E9kLunDRl+XzU3Ti3vxqHNa2oGHQQ9xDjCtNKi1Lw=";

  mypy-boto3-oam = buildMypyBoto3Package "oam" "1.34.0" "sha256-/0ou6QtLQerkqJ+alocpYxUfe9jRHoOgQy9R6sxZAFo=";

  mypy-boto3-omics = buildMypyBoto3Package "omics" "1.34.7" "sha256-Mtb11Oe2j28u+MFaycvMMNiqi7ZdVDcKQV/X/7npze4=";

  mypy-boto3-opensearch = buildMypyBoto3Package "opensearch" "1.34.43" "sha256-EOl56YqzuIUWlSewnVCtEdzt3Ei5yueP4emtTQq3QrA=";

  mypy-boto3-opensearchserverless = buildMypyBoto3Package "opensearchserverless" "1.34.0" "sha256-YpbQWnVIXMqTzieWya4MiFz9HpN5YYSSmBjUvmO0VMo=";

  mypy-boto3-opsworks = buildMypyBoto3Package "opsworks" "1.34.0" "sha256-398ugKoRKeRqIH/1upx1K6d0Y/WIsMJCNM2Mmwk+S/A=";

  mypy-boto3-opsworkscm = buildMypyBoto3Package "opsworkscm" "1.34.0" "sha256-HsUXwbXRPmEaSJjs4EezSHugssLtP2g/NvaI0CnGStA=";

  mypy-boto3-organizations = buildMypyBoto3Package "organizations" "1.34.56" "sha256-iVOUgkTI0sNixbfr/Z/H9Hsc2thCqDCqHrlthneZLVU=";

  mypy-boto3-osis = buildMypyBoto3Package "osis" "1.34.0" "sha256-2mSI1VTmQWuwxsCgQtmr1w8xE3zIcwztvMuKMqXFF3k=";

  mypy-boto3-outposts = buildMypyBoto3Package "outposts" "1.34.27" "sha256-nkXVo8Qr2k+pV3SChRezoiU0e2kT9kz1vr2J8MLfm+0=";

  mypy-boto3-panorama = buildMypyBoto3Package "panorama" "1.34.0" "sha256-Pw0yRgawY5TC0OIgcYmzK3KEQusyRf3coThpeHL4X30=";

  mypy-boto3-payment-cryptography = buildMypyBoto3Package "payment-cryptography" "1.34.20" "sha256-WdyhWl00Khf3gA6OeWeKrlgFnTvWhk+AFoS2UhM5Haw=";

  mypy-boto3-payment-cryptography-data = buildMypyBoto3Package "payment-cryptography-data" "1.34.58" "sha256-mc4NO3yjdLlXc9TBkmIsGFqNfW2RT7/jVMC9uhug4tc=";

  mypy-boto3-pca-connector-ad = buildMypyBoto3Package "pca-connector-ad" "1.34.0" "sha256-pSGVZPLuj8xcSfLqa+xvf4UL/l2Xb5t43KuXlTCfskc=";

  mypy-boto3-personalize = buildMypyBoto3Package "personalize" "1.34.20" "sha256-1Q+rXczO15oM/KXRLVP8D96HW4nILpxig4stjT1KwuY=";

  mypy-boto3-personalize-events = buildMypyBoto3Package "personalize-events" "1.34.0" "sha256-dklttvls5In+d9uWONxmhfSOP1TQf+4VMW56JjKICr4=";

  mypy-boto3-personalize-runtime = buildMypyBoto3Package "personalize-runtime" "1.34.20" "sha256-sKEXkOlMb7t4jBQrLLx90wFhCN1R4ZOk8w9kMpKI0os=";

  mypy-boto3-pi = buildMypyBoto3Package "pi" "1.34.0" "sha256-97giGYtpINPHxtcUU6cE/mPF0/r6YfLixAdcC/LGKC0=";

  mypy-boto3-pinpoint = buildMypyBoto3Package "pinpoint" "1.34.0" "sha256-oa8RAEtGeoyGpXq2sJSbEnLXorS6liInO196SGO6D/E=";

  mypy-boto3-pinpoint-email = buildMypyBoto3Package "pinpoint-email" "1.34.0" "sha256-AHwJtYsAxFiEX16L0HZXz9JzjNZck9V40bFwzicMKUE=";

  mypy-boto3-pinpoint-sms-voice = buildMypyBoto3Package "pinpoint-sms-voice" "1.34.0" "sha256-oDhem97q9QpsQNy9zCfWOC1cHup3pvLflClVxeWEBuw=";

  mypy-boto3-pinpoint-sms-voice-v2 = buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.34.0" "sha256-Ci/nnvgq6YbVPHLZVmLDHjF8GHpViVP7mfUJREFKndg=";

  mypy-boto3-pipes = buildMypyBoto3Package "pipes" "1.34.0" "sha256-c/N5SaT4BS0Ldv/P6yi43gB4LzDeqB9y1Xx1UAHf6dU=";

  mypy-boto3-polly = buildMypyBoto3Package "polly" "1.34.43" "sha256-rx5sW32N6H47fpy5yGvwlKKVKS/uIKOtLfsjoGoNPJg=";

  mypy-boto3-pricing = buildMypyBoto3Package "pricing" "1.34.69" "sha256-0+bak3+4FQK0vAjI1r7uKvhwspZxt/zLCJRVMvH41qs=";

  mypy-boto3-privatenetworks = buildMypyBoto3Package "privatenetworks" "1.34.0" "sha256-WFX0KaJRo0LCPKEAq8LES0P3WJkt6ywLXqTlOFZyZ1w=";

  mypy-boto3-proton = buildMypyBoto3Package "proton" "1.34.0" "sha256-wRBMw/7PWi0s9sJTfnDq3MXcbA5pKwogMDC3UZtLJoY=";

  mypy-boto3-qldb = buildMypyBoto3Package "qldb" "1.34.49" "sha256-yiqWryr4vKt/6k+dVoDMDdtL6yP4ClVY0rFwZDDcvWY=";

  mypy-boto3-qldb-session = buildMypyBoto3Package "qldb-session" "1.34.0" "sha256-JHePiaFCfIJPxZzvC1U38xrBGkDvB9+yKwPecaZl7BY=";

  mypy-boto3-quicksight = buildMypyBoto3Package "quicksight" "1.34.53" "sha256-aN1W1Hu/gyV181x68VNkbBp2Ua4jpJB3H/vmQ0HO1Nw=";

  mypy-boto3-ram = buildMypyBoto3Package "ram" "1.34.0" "sha256-9sOspEfirpVQ8cT9ILUSWypxBswpAD75A0hHRV7glNg=";

  mypy-boto3-rbin = buildMypyBoto3Package "rbin" "1.34.0" "sha256-Y+a/p3r5IgWk4oH6MOeq0e7rMiNvLCqoz1ZE+xXNtOw=";

  mypy-boto3-rds = buildMypyBoto3Package "rds" "1.34.65" "sha256-uEgsI/MsacidGZEYWhvXDVE2RUFdtuh027YZbL4Lyb8=";

  mypy-boto3-rds-data = buildMypyBoto3Package "rds-data" "1.34.6" "sha256-d+WXt3cSUe5ZxynSjPSJxXgv6evP/rhZrX1ua9rtSx8=";

  mypy-boto3-redshift = buildMypyBoto3Package "redshift" "1.34.57" "sha256-MDhI9DW5I6SWXIAnENiPqSanDjCB3vf2n24eVxzmtso=";

  mypy-boto3-redshift-data = buildMypyBoto3Package "redshift-data" "1.34.0" "sha256-NdBZxkLTwnY7fgmoqGZKTN/lhCyY/3VGFWWOGeCf//0=";

  mypy-boto3-redshift-serverless = buildMypyBoto3Package "redshift-serverless" "1.34.16" "sha256-ag5tKb1+4cHiG99OszDNGdnX9RPRPraaqM8p3IqgLBg=";

  mypy-boto3-rekognition = buildMypyBoto3Package "rekognition" "1.34.20" "sha256-zKJX/AlDoDKUbrI1LZq2kk5fr+SNqES6gniM0FQGeaM=";

  mypy-boto3-resiliencehub = buildMypyBoto3Package "resiliencehub" "1.34.0" "sha256-F/ZRCp/M/6kBI4Apb3mISzqe1Zi4Y7gq/vu0dvyyTvM=";

  mypy-boto3-resource-explorer-2 = buildMypyBoto3Package "resource-explorer-2" "1.34.41" "sha256-Q4MCAvEZkYRnDLEF9d8x+FOMUJ9O2eCb2mZr/e8Ut24=";

  mypy-boto3-resource-groups = buildMypyBoto3Package "resource-groups" "1.34.0" "sha256-Wz1Oo/Ze6ROHkg5EAas7ZKLOWE6RS+uKpNea79WUrLY=";

  mypy-boto3-resourcegroupstaggingapi = buildMypyBoto3Package "resourcegroupstaggingapi" "1.34.0" "sha256-ko55TJeH/EGsAp1Y8ZTYhmGEqWGKQTnN3IQEF31V6Ns=";

  mypy-boto3-robomaker = buildMypyBoto3Package "robomaker" "1.34.0" "sha256-dAL2P2bxhSc5oLZXhhekrt9y4bWXg7kIr+/FVbkFTww=";

  mypy-boto3-rolesanywhere = buildMypyBoto3Package "rolesanywhere" "1.34.69" "sha256-wuPEIXHDNvPOWIKLRx5ZR/SgQaWEYqA+IHNR3NZDhIs=";

  mypy-boto3-route53 = buildMypyBoto3Package "route53" "1.34.31" "sha256-MtmEtt57vhFRG1O+VnFXFUhSWAQ7JrnV3hBZx4TpOh8=";

  mypy-boto3-route53-recovery-cluster = buildMypyBoto3Package "route53-recovery-cluster" "1.34.0" "sha256-1IUmycikAtBBNykch2aj7tI6XLRjN7D56YwJn6QRmIQ=";

  mypy-boto3-route53-recovery-control-config = buildMypyBoto3Package "route53-recovery-control-config" "1.34.0" "sha256-hlwovA3tocSTUzsj+TH4VMO/bDrxDNALrAFiTpcgNa0=";

  mypy-boto3-route53-recovery-readiness = buildMypyBoto3Package "route53-recovery-readiness" "1.34.0" "sha256-DyNRWZ9daJ6VFa7moTjgEIdxcCRgjvZ2n7UKyNfr9z4=";

  mypy-boto3-route53domains = buildMypyBoto3Package "route53domains" "1.34.40" "sha256-N81sytOFacuG3pHSk35QbxVxUVEZUx8DK4Y7uUonyh4=";

  mypy-boto3-route53resolver = buildMypyBoto3Package "route53resolver" "1.34.15" "sha256-ER9jhGIeEeHc0llpy4aqRnI9iFfubJFIik04gB81vr0=";

  mypy-boto3-rum = buildMypyBoto3Package "rum" "1.34.49" "sha256-Mq2H+13cjxYRwFfxJpWTAb+W5bx+Vew+jl+zbreRIkQ=";

  mypy-boto3-s3 = buildMypyBoto3Package "s3" "1.34.65" "sha256-L830Es4pJLLws021mr8GqcC75M0zYfFPDSweIRwPfd0=";

  mypy-boto3-s3control = buildMypyBoto3Package "s3control" "1.34.18" "sha256-53s5ii1gFX9toigiazEtS5Jogg3VFFr+1/uiLzoU7Uo=";

  mypy-boto3-s3outposts = buildMypyBoto3Package "s3outposts" "1.34.0" "sha256-xLuGP9Fe0S7zRimt1AKd9KOrytmNd/GTRg5OVi5Xpos=";

  mypy-boto3-sagemaker = buildMypyBoto3Package "sagemaker" "1.34.70" "sha256-WON2j0ZQ9x3qq1mOOzMvT8jJSuJipDHDp4IxsB88GCg=";

  mypy-boto3-sagemaker-a2i-runtime = buildMypyBoto3Package "sagemaker-a2i-runtime" "1.34.0" "sha256-jMZ3aWKQPhNec4A/02S1waQi6Mx9JVdENc3kblhsKjA=";

  mypy-boto3-sagemaker-edge = buildMypyBoto3Package "sagemaker-edge" "1.34.0" "sha256-F3IN/KA7uzS16HZydXmFXlXseNIdhCais6Abfq7gRdI=";

  mypy-boto3-sagemaker-featurestore-runtime = buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.34.22" "sha256-4dFjwJSTgudHHgpVl2TxUl8fWskuzWO+BhTqa5k+4mw=";

  mypy-boto3-sagemaker-geospatial = buildMypyBoto3Package "sagemaker-geospatial" "1.34.0" "sha256-9hKKH/025QQYLrlXCOAQoxuWzTMQlmLSov/hVsubF7M=";

  mypy-boto3-sagemaker-metrics = buildMypyBoto3Package "sagemaker-metrics" "1.34.0" "sha256-KniU+0ZJKfjrBKDDZz+QyLb1oomSeD/K6fcJgmMAcJQ=";

  mypy-boto3-sagemaker-runtime = buildMypyBoto3Package "sagemaker-runtime" "1.34.0" "sha256-OJYEdi4xILUZoePcGBcLRHAhwppeybNO+l0kyW3a0Co=";

  mypy-boto3-savingsplans = buildMypyBoto3Package "savingsplans" "1.34.67" "sha256-t+0Ko+Onv24p1Sn59mvR/auXkDTowOEpKwpzuMUqk8w=";

  mypy-boto3-scheduler = buildMypyBoto3Package "scheduler" "1.34.0" "sha256-+gnQjWPtp7KVI/qIY2aXHD9iM7RZIDl0JwRostfhjzc=";

  mypy-boto3-schemas = buildMypyBoto3Package "schemas" "1.34.0" "sha256-OyWnGUQZKwmAw7tRMt63wG7puIWA7WPyV/rZfPO/KSc=";

  mypy-boto3-sdb = buildMypyBoto3Package "sdb" "1.34.0" "sha256-13BuAQD8uDwwDhCw+8O3V882H6/oor5Z8mBmjb7HHAU=";

  mypy-boto3-secretsmanager = buildMypyBoto3Package "secretsmanager" "1.34.72" "sha256-0HM8W1Potee9oA9LQu2ErxLjaiDISJF+ScFzoEIu8Dw=";

  mypy-boto3-securityhub = buildMypyBoto3Package "securityhub" "1.34.69" "sha256-2fJx1VaOhYSjTXAEboBhHhMdTH697zcGHmrJsGknDTI=";

  mypy-boto3-securitylake = buildMypyBoto3Package "securitylake" "1.34.53" "sha256-O/RHRoeUYT5DerEXIQ1NL288bcgA6bGdI29sN7WoQac=";

  mypy-boto3-serverlessrepo = buildMypyBoto3Package "serverlessrepo" "1.34.0" "sha256-abWCJqFbD/AyPV+7hmY4OlsedFs+p8WpNSXG7hjrj3s=";

  mypy-boto3-service-quotas = buildMypyBoto3Package "service-quotas" "1.34.0" "sha256-wWbm/udCn5Je1gJZ+uDJ4LE8NbQlq1yHVQc6eQ2umIw=";

  mypy-boto3-servicecatalog = buildMypyBoto3Package "servicecatalog" "1.34.13" "sha256-60XUP/uZDAkB0RaJgUD4wk+DknbsuygMnTmc3bKlr3U=";

  mypy-boto3-servicecatalog-appregistry = buildMypyBoto3Package "servicecatalog-appregistry" "1.34.0" "sha256-XYqa3aiC9pasmkMDXFmHKuK/PWwi6fZs/pt7rXuRFDw=";

  mypy-boto3-servicediscovery = buildMypyBoto3Package "servicediscovery" "1.34.0" "sha256-h9wTiaEakgBlrlwzUulqoEMWmVAKV/METiQppUC+FVI=";

  mypy-boto3-ses = buildMypyBoto3Package "ses" "1.34.0" "sha256-ieFDjZ8tTPM5wCRWFjNNUuDKOj8K4s4NH1SiJXxbnaQ=";

  mypy-boto3-sesv2 = buildMypyBoto3Package "sesv2" "1.34.56" "sha256-xW5M8RMTSqRvRfbb3+zeL3i3tWO3w8+G9eMgbhI6K9I=";

  mypy-boto3-shield = buildMypyBoto3Package "shield" "1.34.0" "sha256-w0D4JKdlitCBIF3NaKn+POYch5CPGIiUZXqBoFzjzz4=";

  mypy-boto3-signer = buildMypyBoto3Package "signer" "1.34.0" "sha256-wR7ZQ8zTjuVPwMqQ7TR+93DWld9JU16rlt2X+z29xZI=";

  mypy-boto3-simspaceweaver = buildMypyBoto3Package "simspaceweaver" "1.34.0" "sha256-3J7s6FMRBcI7XaVoXjB3gSNI/Eh7TrE5ij8wRmagK/M=";

  mypy-boto3-sms = buildMypyBoto3Package "sms" "1.34.0" "sha256-ktneEYqlmdhb386de2oQuDN5W4FLTxjWBmnZ0COVASA=";

  mypy-boto3-sms-voice = buildMypyBoto3Package "sms-voice" "1.34.0" "sha256-KaF8cWo+vin1YA63S6PDTpvjKWtz0Akl18yMVvhjdLo=";

  mypy-boto3-snow-device-management = buildMypyBoto3Package "snow-device-management" "1.34.0" "sha256-buPLN3Qu+asEf2qrv1Jvhu3gKN6aBrK55jB8IxPoFMs=";

  mypy-boto3-snowball = buildMypyBoto3Package "snowball" "1.34.58" "sha256-z60jinh1shgZv2Q4uW2eFphJXRC0ONVN5bPE1UBgC9Y=";

  mypy-boto3-sns = buildMypyBoto3Package "sns" "1.34.44" "sha256-qYW1KB0AoVbdfJCT5YE8EMTqa5Hy67cVZ/57t7IQplI=";

  mypy-boto3-sqs = buildMypyBoto3Package "sqs" "1.34.0" "sha256-C/iZX1iRmrKVOYEA5y6qfaiYrc/Z0zmkLzxIzkc0GdU=";

  mypy-boto3-ssm = buildMypyBoto3Package "ssm" "1.34.61" "sha256-TLyZ9CtpE8U2xsxBwC0/Flkg0ee6u5uxd4K0EFVs3gA=";

  mypy-boto3-ssm-contacts = buildMypyBoto3Package "ssm-contacts" "1.34.0" "sha256-wkKPGLm24/zgMKitcF9ZaPt/W4m+yHerR1wbEqJALBM=";

  mypy-boto3-ssm-incidents = buildMypyBoto3Package "ssm-incidents" "1.34.0" "sha256-OB5/E5ZArGtLZ/UaVjDEnzoH4J4vEFehULG8RKCB6gg=";

  mypy-boto3-ssm-sap = buildMypyBoto3Package "ssm-sap" "1.34.0" "sha256-Sz3inwP5mRKJdFqrf5FYmTp6M9o8J/S4H6k/7SMq25E=";

  mypy-boto3-sso = buildMypyBoto3Package "sso" "1.34.0" "sha256-Iu1KwyWW8DjFJcV46L50gK/G8p2nAqxzzjgBAVTX6nU=";

  mypy-boto3-sso-admin = buildMypyBoto3Package "sso-admin" "1.34.0" "sha256-befPkyehC4AKxMotvRzyfZpkqlpkfpI2OKVSw4IFnjo=";

  mypy-boto3-sso-oidc = buildMypyBoto3Package "sso-oidc" "1.34.0" "sha256-uDHRoc7H3vtM/KYSeH95PdibjiEq/pSSJFcm5kgMMAg=";

  mypy-boto3-stepfunctions = buildMypyBoto3Package "stepfunctions" "1.34.0" "sha256-BtIpbO51DRfLYhcUIO6kYU8g8pvkXuNhhU+LWZpugRA=";

  mypy-boto3-storagegateway = buildMypyBoto3Package "storagegateway" "1.34.27" "sha256-iKn048AdvM6XSOqT/w6edWoe0VMi3V305oHMth/QkF0=";

  mypy-boto3-sts = buildMypyBoto3Package "sts" "1.34.0" "sha256-s0fgozbWAWLdlAdNnRD2FPKwmkVcm0JBWFDVTWduIGc=";

  mypy-boto3-support = buildMypyBoto3Package "support" "1.34.0" "sha256-3y+uFRJKahLAPoG9gqxK8gqZKJ+OL1Rom/dr/zWIq+k=";

  mypy-boto3-support-app = buildMypyBoto3Package "support-app" "1.34.0" "sha256-/aYEPAnGgAPB6Tnh5jwYASbP2kVJth+3ZxcMCYgo9n0=";

  mypy-boto3-swf = buildMypyBoto3Package "swf" "1.34.0" "sha256-T8QYHzRjjQyLGqSwc7J6hPXqpeoeCUvlpHbXwnT99rQ=";

  mypy-boto3-synthetics = buildMypyBoto3Package "synthetics" "1.34.0" "sha256-gGEu4vQ5T1gSLM33V8Ouj+ZlPQIoY+RRbUz7nvD7PbY=";

  mypy-boto3-textract = buildMypyBoto3Package "textract" "1.34.0" "sha256-AeukQ85jOCNpUxfnedEyacm/bK6pFA32tmhQrieLoMo=";

  mypy-boto3-timestream-query = buildMypyBoto3Package "timestream-query" "1.34.65" "sha256-RSGOulFIOZi/9Z5grP/Zv0A5fy3MJTzph+D9a45MkHA=";

  mypy-boto3-timestream-write = buildMypyBoto3Package "timestream-write" "1.34.0" "sha256-fKi5nIyU5BffflHVh21HjcuYE+RXDiq0gXbFOKOAYPE=";

  mypy-boto3-tnb = buildMypyBoto3Package "tnb" "1.34.0" "sha256-32Pcqs7DamX+sZt3pDF+gCjnAs8JhtJm9+Jl0agIuOA=";

  mypy-boto3-transcribe = buildMypyBoto3Package "transcribe" "1.34.0" "sha256-cKiJ306Y96xLHB7vX46uaw145BPLK/1g3OrMIMB0pPo=";

  mypy-boto3-transfer = buildMypyBoto3Package "transfer" "1.34.59" "sha256-bx3Ur5TzB/1kxfYT91Aww148ppFmcvjs2rdM/1bWBUo=";

  mypy-boto3-translate = buildMypyBoto3Package "translate" "1.34.0" "sha256-4tjjmwMtIPpMwKZ3yqB96XEb1WidCxMIj2Cfjn0nTy8=";

  mypy-boto3-verifiedpermissions = buildMypyBoto3Package "verifiedpermissions" "1.34.57" "sha256-odSCs7qud4UQ9/ZZOLEg9k/9fb0ZJQqY2A9sV9s5CPA=";

  mypy-boto3-voice-id = buildMypyBoto3Package "voice-id" "1.34.0" "sha256-c6HseKIqRPs8NmFZYsg+9jWCMGpMi+VpvM9BiWq16PY=";

  mypy-boto3-vpc-lattice = buildMypyBoto3Package "vpc-lattice" "1.34.0" "sha256-zyqcDplqAYFrUjrz28SHrIemPSTzvfUb7x6CXxXCTNc=";

  mypy-boto3-waf = buildMypyBoto3Package "waf" "1.34.0" "sha256-TVOBwTITXBYFoGvXULoi8OL7OJXZKJbCpZPaZ5siWXk=";

  mypy-boto3-waf-regional = buildMypyBoto3Package "waf-regional" "1.34.0" "sha256-zv/IPDU6lqmmIfTq57d7VH3SyA7UkgWW2Hysk2zamcM=";

  mypy-boto3-wafv2 = buildMypyBoto3Package "wafv2" "1.34.58" "sha256-gPNY3XJr/50nejQFzti9igktryZHsgQDiB9BOYnT94I=";

  mypy-boto3-wellarchitected = buildMypyBoto3Package "wellarchitected" "1.34.0" "sha256-tzXpOWC6/WJ+/wUgwYtgI7scq7wRpACW8q1z9RwyhbA=";

  mypy-boto3-wisdom = buildMypyBoto3Package "wisdom" "1.34.16" "sha256-VhRrQLqmrHn/uWI6lWFJ27hiSmZbW1y+VE2Uf8ssrOw=";

  mypy-boto3-workdocs = buildMypyBoto3Package "workdocs" "1.34.0" "sha256-96V+xgJ+DvqA4A7teCEpVVirlTVxCehXzNcPWUojPH4=";

  mypy-boto3-worklink = buildMypyBoto3Package "worklink" "1.34.0" "sha256-dEWnbAtuUH14ojkOdeQvPvnVYZYxEsPvXuamyil2AHE=";

  mypy-boto3-workmail = buildMypyBoto3Package "workmail" "1.34.0" "sha256-D0gfIW2sbxQ/JOi5f9S6/KezsEKz4239srdL8EfFjG8=";

  mypy-boto3-workmailmessageflow = buildMypyBoto3Package "workmailmessageflow" "1.34.0" "sha256-e4wgFvtlfx0u6eGphRU7viGzZ4gbZijj4vjziPLPWX8=";

  mypy-boto3-workspaces = buildMypyBoto3Package "workspaces" "1.34.58" "sha256-EtAL93MtIZppL57xP4JDGoWT/SqgptRgCJyq/3bm9ts=";

  mypy-boto3-workspaces-web = buildMypyBoto3Package "workspaces-web" "1.34.0" "sha256-RImlbT5Lpu2IoTrEQv5Bzk3NnkMV9jQjHGDnxCK3x18=";

  mypy-boto3-xray = buildMypyBoto3Package "xray" "1.34.0" "sha256-8weFeYAit/DBFOhReQr5uSy0Am7Sh1fpYtMPtDka+OI=";

}
