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
  mypy-boto3-accessanalyzer = buildMypyBoto3Package "accessanalyzer" "1.33.0" "sha256-vMCXbHr4KBnS5/+JsAkEvH6cNunhKfL9iHy7aJcXewc=";

  mypy-boto3-account = buildMypyBoto3Package "account" "1.33.0" "sha256-zlIowNkhrcmd1EKmFNv02Ju7QdspY1A+wkEoMkm0nzU=";

  mypy-boto3-acm = buildMypyBoto3Package "acm" "1.33.0" "sha256-RS4tjBXCxVmFIyJFa58xkZ2uZ2JKhRK8UW3yWES03fg=";

  mypy-boto3-acm-pca = buildMypyBoto3Package "acm-pca" "1.33.0" "sha256-+Vw+Wu2d2LWgBnCWyxyPqqydz65+7n2eGqf0yQKI7vo=";

  mypy-boto3-alexaforbusiness = buildMypyBoto3Package "alexaforbusiness" "1.33.0" "sha256-OtJG+0AHy9TLhwAQ6mqKAni5OYvrXT8thexqlfAcuZA=";

  mypy-boto3-amp = buildMypyBoto3Package "amp" "1.33.0" "sha256-I9qhqdcZYZCZrnA+cVhauuKNTRUR/u/Cic9dkswXwQw=";

  mypy-boto3-amplify = buildMypyBoto3Package "amplify" "1.33.0" "sha256-x11Kf3OBTuWIiy60uUF+PTuIoyfkKSCH1ioQBKYVhGo=";

  mypy-boto3-amplifybackend = buildMypyBoto3Package "amplifybackend" "1.33.0" "sha256-RmJogNY21Z5W4mlKJm97vZgdpCFECgz2I8CvvP7KKuA=";

  mypy-boto3-amplifyuibuilder = buildMypyBoto3Package "amplifyuibuilder" "1.33.0" "sha256-vqAb/St9HKOxROQxKUtk1cf6oFtI6Q3cS9yd5uQbYDQ=";

  mypy-boto3-apigateway = buildMypyBoto3Package "apigateway" "1.33.0" "sha256-H466PQQ7WRODEB+P2WdabufzwU1p3sJqUZFf8zZ/Jew=";

  mypy-boto3-apigatewaymanagementapi = buildMypyBoto3Package "apigatewaymanagementapi" "1.33.0" "sha256-uZi7fn3DvR2X5hhFUi3zo1cE78ejcmdxZMqP93R3GwY=";

  mypy-boto3-apigatewayv2 = buildMypyBoto3Package "apigatewayv2" "1.33.0" "sha256-BAJDfn/j+nSgkG/vKNfjy3DtTexugEe8LbFjc11JFiU=";

  mypy-boto3-appconfig = buildMypyBoto3Package "appconfig" "1.33.0" "sha256-NeCWgqnin0sWJU4J9AVKqiD9LArQc95wLV8klpH3JTs=";

  mypy-boto3-appconfigdata = buildMypyBoto3Package "appconfigdata" "1.33.0" "sha256-e5CPQ59eDyVv49ysOz7PxSCBSWYfcQfwFo88+Wy9cxM=";

  mypy-boto3-appfabric = buildMypyBoto3Package "appfabric" "1.33.0" "sha256-bbHT2jZ9A0VzBHJdkm9bmfx3dJAcjq44+p61X5QPLMU=";

  mypy-boto3-appflow = buildMypyBoto3Package "appflow" "1.33.0" "sha256-M2T3BLb8FDI54BGSb6gQLKR1yfwpfyCe1Zrf+QJTo00=";

  mypy-boto3-appintegrations = buildMypyBoto3Package "appintegrations" "1.33.0" "sha256-tXPrHbajCuDlthoCmbyv63G1uDfAkU1v/mtLd6gRoTQ=";

  mypy-boto3-application-autoscaling = buildMypyBoto3Package "application-autoscaling" "1.33.0" "sha256-wagkMudXHGi0Ig09wkUkyetf+w4SZ98kSGifJ/GAd0Y=";

  mypy-boto3-application-insights = buildMypyBoto3Package "application-insights" "1.33.0" "sha256-RUY36tYgRFlkE2obN+hyS9fWzcfSAu2uWHragLx4mBk=";

  mypy-boto3-applicationcostprofiler = buildMypyBoto3Package "applicationcostprofiler" "1.33.0" "sha256-RqiVyR+Ri5GgeWgbw3bxfRdsqEuu4r27ic+AIHh8f0Y=";

  mypy-boto3-appmesh = buildMypyBoto3Package "appmesh" "1.33.0" "sha256-Ym7Sv9SRT0qGNvE2KvQgOjen0bkRn5IP2LcMMgwuqck=";

  mypy-boto3-apprunner = buildMypyBoto3Package "apprunner" "1.33.0" "sha256-Cmpfuzt3HMm7Zz65Onc6CLi6kbmROOdBJohvfh//Vf8=";

  mypy-boto3-appstream = buildMypyBoto3Package "appstream" "1.33.0" "sha256-pacvBvLAe+NX4dkNvo3i71DPNJfOmh2yjESH8oVEuFE=";

  mypy-boto3-appsync = buildMypyBoto3Package "appsync" "1.33.0" "sha256-y4po1QAdhzeLlGJd0tPVt6q+vo/2usTJko+YiZGCxUQ=";

  mypy-boto3-arc-zonal-shift = buildMypyBoto3Package "arc-zonal-shift" "1.33.0" "sha256-tjkWwVBPctELUzqd1+OhlSZQ6g1Tx6KAgsvg5XWG3cs=";

  mypy-boto3-athena = buildMypyBoto3Package "athena" "1.33.0" "sha256-31x7uJbstgTLFxO2BfxLgvwm0yMfM5AxyfOV7KTczDg=";

  mypy-boto3-auditmanager = buildMypyBoto3Package "auditmanager" "1.33.0" "sha256-5hTjU01PR5YOg4AbD8m4ypvH7cyN2wBFI7FTOZ7Im98=";

  mypy-boto3-autoscaling = buildMypyBoto3Package "autoscaling" "1.33.0" "sha256-v6eyiIa1WBLDsJBO6VCCYm4XI6GxD4gKAfvbi9ejGHI=";

  mypy-boto3-autoscaling-plans = buildMypyBoto3Package "autoscaling-plans" "1.33.0" "sha256-fOlymQRIl1laVKIdMl5b5w1hyzmhVZtmn90HGWaOR54=";

  mypy-boto3-backup = buildMypyBoto3Package "backup" "1.33.0" "sha256-/v6v4H17liB6uE3QvQ1FQNXERRF77lC10hXlGMqpSvU=";

  mypy-boto3-backup-gateway = buildMypyBoto3Package "backup-gateway" "1.33.0" "sha256-3KRJpqQ2mJRDt1vtkUk08G3HTtK8kzSfVUKg9xhhiCE=";

  mypy-boto3-backupstorage = buildMypyBoto3Package "backupstorage" "1.33.0" "sha256-srsIuy46OQtS+SLLAxP2S9M2spmNmk5YySpxXxbUTLQ=";

  mypy-boto3-batch = buildMypyBoto3Package "batch" "1.33.0" "sha256-neEJR2+VO+LWUvBKUiSxl/tKd8NAsk2I+kNCxlZvebc=";

  mypy-boto3-billingconductor = buildMypyBoto3Package "billingconductor" "1.33.0" "sha256-G2sSf2u6z4V6z0y4CpcZmWqBqmbU6saJ6PC/dy6MHXA=";

  mypy-boto3-braket = buildMypyBoto3Package "braket" "1.33.0" "sha256-dT10CoHYHltRVw7bJWnLKXgvAmf3939UG2D9QC5vPto=";

  mypy-boto3-budgets = buildMypyBoto3Package "budgets" "1.33.0" "sha256-EFjmFk2M/PZSKmV9hKRHD1m+OdkhslH+o1CzjWGi3Yw=";

  mypy-boto3-ce = buildMypyBoto3Package "ce" "1.33.0" "sha256-n3pwBgiUHenjVZV5pmOwKBhcV624KSPd4oAGtSGcAEw=";

  mypy-boto3-chime = buildMypyBoto3Package "chime" "1.33.0" "sha256-d4HTdcPAsLsKaEYyjYIgHTUInoq+6+2pLD3xaaIy1NE=";

  mypy-boto3-chime-sdk-identity = buildMypyBoto3Package "chime-sdk-identity" "1.33.0" "sha256-hRtjkfgsmESggrV0J3uEpLBWYUHbYWDmIEJeLfvJ5yo=";

  mypy-boto3-chime-sdk-media-pipelines = buildMypyBoto3Package "chime-sdk-media-pipelines" "1.33.0" "sha256-g0NrdkJvqQvw9Zbym/XNQwFcRlU3O/FUXQHIOejI6SE=";

  mypy-boto3-chime-sdk-meetings = buildMypyBoto3Package "chime-sdk-meetings" "1.33.0" "sha256-Q3RVAUlHKfBtjabs+0oP6n3rzQjl1iDPlvczPQ2MVJI=";

  mypy-boto3-chime-sdk-messaging = buildMypyBoto3Package "chime-sdk-messaging" "1.33.0" "sha256-9nHNncPMG6HEoyKRIeyDlqBZtjDNbPE3ML/6RMOw3fE=";

  mypy-boto3-chime-sdk-voice = buildMypyBoto3Package "chime-sdk-voice" "1.33.0" "sha256-WrVolMHBmZxJZc5ckx4dW7CrFgw1jQ/Xu+SoiuZcFk8=";

  mypy-boto3-cleanrooms = buildMypyBoto3Package "cleanrooms" "1.33.0" "sha256-+7zWiyuTMACJlIXOt2tfh7hARJTVNtkwspq+PZj/LDU=";

  mypy-boto3-cloud9 = buildMypyBoto3Package "cloud9" "1.33.0" "sha256-lVyuvJVIEXPAzXJp11/wERjuV2RjAV/XcqrazjtcRfo=";

  mypy-boto3-cloudcontrol = buildMypyBoto3Package "cloudcontrol" "1.33.0" "sha256-RHK2TqnQFILrBeokVKL8GHvJvDBz10AqGpRanV6dIGo=";

  mypy-boto3-clouddirectory = buildMypyBoto3Package "clouddirectory" "1.33.0" "sha256-IpVWNZIjbpQqCL09vjMVDADN9dgvlYpiZFJPLUH7He8=";

  mypy-boto3-cloudformation = buildMypyBoto3Package "cloudformation" "1.33.0" "sha256-4cJ7kQ/86W7QrhJuTFdVvdkKVtx1SOVDJkM0o1YI3wo=";

  mypy-boto3-cloudfront = buildMypyBoto3Package "cloudfront" "1.33.0" "sha256-gYC17Q/+LJN2tbjmhqbh4Q5EyDQ5Xav5mCNJMfWZU00=";

  mypy-boto3-cloudhsm = buildMypyBoto3Package "cloudhsm" "1.33.0" "sha256-BLV4xkuGmO5GpNEWTwVM/y8uTDq3y8CiGMxaGhLV+lc=";

  mypy-boto3-cloudhsmv2 = buildMypyBoto3Package "cloudhsmv2" "1.33.0" "sha256-Tt7+PuHmJF6YXpqOTNvRqXy/21p4gGWNS/1oZZ+Y6VI=";

  mypy-boto3-cloudsearch = buildMypyBoto3Package "cloudsearch" "1.33.0" "sha256-3sUa5Zprpu9UPJobha7cpmEHOy4J6DqqZEwrx6J5FuI=";

  mypy-boto3-cloudsearchdomain = buildMypyBoto3Package "cloudsearchdomain" "1.33.0" "sha256-El4jMC108xp7i9GMmKCh+9vLJVDDfL0Nm3fGUHJ/fUg=";

  mypy-boto3-cloudtrail = buildMypyBoto3Package "cloudtrail" "1.33.0" "sha256-GuLMHXZJaH0FB1k/PXdGJ7grJqPEbv5FcldOfLLmzjI=";

  mypy-boto3-cloudtrail-data = buildMypyBoto3Package "cloudtrail-data" "1.33.0" "sha256-v9VN8J9JhraI1kYWVPmbmjwsmvfLMFHWfRtPKsqO3kQ=";

  mypy-boto3-cloudwatch = buildMypyBoto3Package "cloudwatch" "1.33.0" "sha256-Z2CPz3XnPtvUzBen8P573pjaC929pj2DH9fpT9m+J7U=";

  mypy-boto3-codeartifact = buildMypyBoto3Package "codeartifact" "1.33.0" "sha256-QgsHW6+E+FXntXewov7OL7l+6moIh88+fqyDbDRCvEs=";

  mypy-boto3-codebuild = buildMypyBoto3Package "codebuild" "1.33.0" "sha256-FKelhXfxoVEtuzF1yb8sM/UsUpO5jDGw6/6lrYJAjvw=";

  mypy-boto3-codecatalyst = buildMypyBoto3Package "codecatalyst" "1.33.0" "sha256-Uy7hD2FA9I31OBM+bNtusf8YqYr9p9nQc1TMt9NteIY=";

  mypy-boto3-codecommit = buildMypyBoto3Package "codecommit" "1.33.0" "sha256-SveFV+4iwElAJZnLhikzUwQTr4HF6rVJjc9g+uaIoHA=";

  mypy-boto3-codedeploy = buildMypyBoto3Package "codedeploy" "1.33.0" "sha256-7unbEySxhvNSpc4YANJRtu+ehT7GcypZE5N9eqPKUm4=";

  mypy-boto3-codeguru-reviewer = buildMypyBoto3Package "codeguru-reviewer" "1.33.0" "sha256-6P2i+D3mhjQxIQRHbXDyOtj9BC6Wc+xTR9v41fhMiNc=";

  mypy-boto3-codeguru-security = buildMypyBoto3Package "codeguru-security" "1.33.0" "sha256-JviDGZinwF69HHaLrS7tHMBnJwfDpwzdbl4qCw1dK0E=";

  mypy-boto3-codeguruprofiler = buildMypyBoto3Package "codeguruprofiler" "1.33.0" "sha256-jln4ciHJpQCV36jBLBWfGJZI55L2FneelWqeHpmQF8w=";

  mypy-boto3-codepipeline = buildMypyBoto3Package "codepipeline" "1.33.0" "sha256-wXA/n5j9v7Z1jBcH++CAOW9W0EhqJJHhbKh8mKzc5GQ=";

  mypy-boto3-codestar = buildMypyBoto3Package "codestar" "1.33.0" "sha256-6XVO8euPDjXZk/5qVS4EX5JfLhqYFUTdUQKqzoI0Gw8=";

  mypy-boto3-codestar-connections = buildMypyBoto3Package "codestar-connections" "1.33.0" "sha256-Vow7PuIH3qrtuJBiG83OpNC+Gtav9CzVx5iUV9bFTXE=";

  mypy-boto3-codestar-notifications = buildMypyBoto3Package "codestar-notifications" "1.33.0" "sha256-uG1tCFQzfxRtzE178XOKUv7/KtyrPMSd5HwVhWCq2x0=";

  mypy-boto3-cognito-identity = buildMypyBoto3Package "cognito-identity" "1.33.0" "sha256-4rQsSCe4X/JoJ0a2xJsjIyXIQUU7aTNYKCBD8KjabFQ=";

  mypy-boto3-cognito-idp = buildMypyBoto3Package "cognito-idp" "1.33.0" "sha256-wa7iya9T3eJ0A2IwVYa4wwdYaIY6z9tj67qXg3NnvHo=";

  mypy-boto3-cognito-sync = buildMypyBoto3Package "cognito-sync" "1.33.0" "sha256-l+Ox4pOrOSVtix/vQDGCUAk8hGJVCmQ2gLqP6p93j9M=";

  mypy-boto3-comprehend = buildMypyBoto3Package "comprehend" "1.33.0" "sha256-t0UGeom1dihIv9UV0J8mnLmogYcgzgQbN3HhWwcSP5Q=";

  mypy-boto3-comprehendmedical = buildMypyBoto3Package "comprehendmedical" "1.33.0" "sha256-3gYRTNmPewLzLUrdW6WYl/4jl1VSLCANjTgDwUNjXVM=";

  mypy-boto3-compute-optimizer = buildMypyBoto3Package "compute-optimizer" "1.33.0" "sha256-+aig0Rx1mkruERwkkPoVMNcvbGP9Qos/SMpVT+hZeJ8=";

  mypy-boto3-config = buildMypyBoto3Package "config" "1.33.0" "sha256-L/DVirprRQdEvN1zohuZuG9HsU4nGmT4Y5huNQUMdBE=";

  mypy-boto3-connect = buildMypyBoto3Package "connect" "1.33.0" "sha256-kKzUAZzfj2VwVbAOpbQBldRhju8Qcm3YFSmvjxEVtnk=";

  mypy-boto3-connect-contact-lens = buildMypyBoto3Package "connect-contact-lens" "1.33.0" "sha256-xCkxmVk+HL6JX0vfAXzcqI91jnrV/xO/Q28HiIkniTs=";

  mypy-boto3-connectcampaigns = buildMypyBoto3Package "connectcampaigns" "1.33.0" "sha256-qBviSiG54DNJCl6wgXpLhuoC+YoxcQwigl8Hapz7Kp8=";

  mypy-boto3-connectcases = buildMypyBoto3Package "connectcases" "1.33.0" "sha256-uv22P/Lb0f+3GYoo+RNN0fJkrk2hw9tsKZCLEQRqx1M=";

  mypy-boto3-connectparticipant = buildMypyBoto3Package "connectparticipant" "1.33.0" "sha256-LFtTX9onRSByqPVtQzFtLUyhQsLZ48k9cQLzVW1fQAw=";

  mypy-boto3-controltower = buildMypyBoto3Package "controltower" "1.33.0" "sha256-yDL6EWdV6QNexglhMQPBVgbjnvFIBAZpJklRcYidsmw=";

  mypy-boto3-cur = buildMypyBoto3Package "cur" "1.33.0" "sha256-UgVAGcC2VjoCd5FAgmDOo/Yp3wDT18xvRe530XKB9kY=";

  mypy-boto3-customer-profiles = buildMypyBoto3Package "customer-profiles" "1.33.0" "sha256-qODsOFw98FERW9tV+ld+JLtygbUMLrzNn8HZRoePOq4=";

  mypy-boto3-databrew = buildMypyBoto3Package "databrew" "1.33.0" "sha256-izG6CUdV9J991eV9GHzB9FhB9E0KQI57X3BwNZ4q5dc=";

  mypy-boto3-dataexchange = buildMypyBoto3Package "dataexchange" "1.33.0" "sha256-ckVXwvC71J3PHm2YzNbjYTmgXukvwKH9vVYxgewTCO0=";

  mypy-boto3-datapipeline = buildMypyBoto3Package "datapipeline" "1.33.0" "sha256-PsF5H+LtErVeGMcQLKgMhtCTHqm4dl54d6XWL4FGeko=";

  mypy-boto3-datasync = buildMypyBoto3Package "datasync" "1.33.0" "sha256-aniW225MUeoHi9Leukzyf5MDFyIFerM5TKeZG7dtk+o=";

  mypy-boto3-dax = buildMypyBoto3Package "dax" "1.33.0" "sha256-gnfdHHlV/XsACxeF1zKl1c3eYHBLoSe+aZeiXKDNP5k=";

  mypy-boto3-detective = buildMypyBoto3Package "detective" "1.33.0" "sha256-KUuZDe13F+6lMbCaB5vPmbvDJC+n4S7DtXiy/jSCsOk=";

  mypy-boto3-devicefarm = buildMypyBoto3Package "devicefarm" "1.33.0" "sha256-9AvJezXcBraBwjlAr0dsLwecTahCh+Ka93nEFXP9mpk=";

  mypy-boto3-devops-guru = buildMypyBoto3Package "devops-guru" "1.33.0" "sha256-FnMUWCd5bmevyUMsCLw5fipEAFJu1gBscYd0pjzhEHI=";

  mypy-boto3-directconnect = buildMypyBoto3Package "directconnect" "1.33.0" "sha256-reoKObC7jQ1w1vIpXJuLou736rrYkecT/9D9/+d646U=";

  mypy-boto3-discovery = buildMypyBoto3Package "discovery" "1.33.0" "sha256-kbonomcMw1KADJvby/gDoP0IMBTCo0zQzu9nboL37I8=";

  mypy-boto3-dlm = buildMypyBoto3Package "dlm" "1.33.0" "sha256-eCq4HkCU8NeVkCDMwqFG7Jv1UpFjm7NP7fbVOa1QAtQ=";

  mypy-boto3-dms = buildMypyBoto3Package "dms" "1.33.0" "sha256-LSqBrPU8QOhSfLO38Hl2pk7jkczasMgQ5x+xReg6zDw=";

  mypy-boto3-docdb = buildMypyBoto3Package "docdb" "1.33.0" "sha256-fbB6+Kf2q+D8l2VPhb1jQKgAN6nTCjLS5Jba03TThHM=";

  mypy-boto3-docdb-elastic = buildMypyBoto3Package "docdb-elastic" "1.33.0" "sha256-cbqSY2AklKpwtIyH+KZvkB/kG9qXsyPu0isHuWW0Ksg=";

  mypy-boto3-drs = buildMypyBoto3Package "drs" "1.33.0" "sha256-stTCJf4laWLTUtx0PgeDpvYBwQGYAqOzkjQ49OC2F3E=";

  mypy-boto3-ds = buildMypyBoto3Package "ds" "1.33.0" "sha256-uonwAHNaMtkRNFG7AttJC/16Y9I0c3Y+HeGR1HQoFFA=";

  mypy-boto3-dynamodb = buildMypyBoto3Package "dynamodb" "1.33.0" "sha256-LP4Qicid5hsewOaacro+aGWgE+oKN9MYq1ZJg3hdQvk=";

  mypy-boto3-dynamodbstreams = buildMypyBoto3Package "dynamodbstreams" "1.33.0" "sha256-qUlw79EzDxyDD/SJETHcL1hgLPPVLQtHy9ttUYOYDCg=";

  mypy-boto3-ebs = buildMypyBoto3Package "ebs" "1.33.0" "sha256-BQzGF7mxoYV30NtD1f5VL2Ktxci+zPCPBgNsPApnlZA=";

  mypy-boto3-ec2 = buildMypyBoto3Package "ec2" "1.33.0" "sha256-B1eJN/l09hKaediPeI5ToKONIuWpwMY9WJ8k45uPuQ0=";

  mypy-boto3-ec2-instance-connect = buildMypyBoto3Package "ec2-instance-connect" "1.33.0" "sha256-2RI2mM2wuwlyLGitd4NHgbm6qkobNGxoGHImfE5uWxk=";

  mypy-boto3-ecr = buildMypyBoto3Package "ecr" "1.33.0" "sha256-drClP5gm9dUv2SQqzkIPHVTbNdzMw5HFE3SAv7aKFok=";

  mypy-boto3-ecr-public = buildMypyBoto3Package "ecr-public" "1.33.0" "sha256-LMGpAp2RYllfVRFIjsEFboufEAbj2gj+ggBD98bNIRQ=";

  mypy-boto3-ecs = buildMypyBoto3Package "ecs" "1.33.0" "sha256-EAIWm+8G+pEqEgO95kUJ2DRAB7fkIpC2SSrI322IPbs=";

  mypy-boto3-efs = buildMypyBoto3Package "efs" "1.33.0" "sha256-M0ubL5u9o09jr5BR1SFzXUbH/Rqe8llKbLDPRc7GUfU=";

  mypy-boto3-eks = buildMypyBoto3Package "eks" "1.33.0" "sha256-/ducHn1BguExlXGWprc+0hmN5j+HLzI4LcUnVS8s1YY=";

  mypy-boto3-elastic-inference = buildMypyBoto3Package "elastic-inference" "1.33.0" "sha256-OZR49az4reaOs3LRaCZSD9ZCvNTOHlxqe5+431ic1l0=";

  mypy-boto3-elasticache = buildMypyBoto3Package "elasticache" "1.33.0" "sha256-49c2MSiPOgwf15xUBfmaxYmLweEuCB0hU3krgYgeE4E=";

  mypy-boto3-elasticbeanstalk = buildMypyBoto3Package "elasticbeanstalk" "1.33.0" "sha256-VhETIkkLab2rJu/cXl0i7kqdIMLeuI7EuYbjFw7XCPs=";

  mypy-boto3-elastictranscoder = buildMypyBoto3Package "elastictranscoder" "1.33.0" "sha256-LvSqiTmqWJtG7r5JsYkRlOfI+DYI5xHKBb0kMqzR8qY=";

  mypy-boto3-elb = buildMypyBoto3Package "elb" "1.33.0" "sha256-CYrhcIlkFzJoDbzAE1Jp1dFMj2O9KfV4ga7mBSa2hSI=";

  mypy-boto3-elbv2 = buildMypyBoto3Package "elbv2" "1.33.0" "sha256-dz97f3avPQ2vwgOnP+6QLSC5PH5Seq21zHFW65qFmws=";

  mypy-boto3-emr = buildMypyBoto3Package "emr" "1.33.0" "sha256-Jft310TIBXmR6WLKTHZEo+TvwwwR4eQydLkyXjLdIDs=";

  mypy-boto3-emr-containers = buildMypyBoto3Package "emr-containers" "1.33.0" "sha256-slTEVWgnNED2stWdA5HFBc0PqSQkUvj2XGbtSvwv0UU=";

  mypy-boto3-emr-serverless = buildMypyBoto3Package "emr-serverless" "1.33.0" "sha256-uJyoN2Vx1GPc4Ec5va+507fA87iRgWbpO/IfzhtCmBI=";

  mypy-boto3-entityresolution = buildMypyBoto3Package "entityresolution" "1.33.0" "sha256-t5Ip+6TPoWoqhEXcJDoc2IUk/FeYvP+PRo0kypq/jYk=";

  mypy-boto3-es = buildMypyBoto3Package "es" "1.33.0" "sha256-RemWn5vC2MluamPhnZ/aSwf4dK5XnuD2ztTg7/6MqYc=";

  mypy-boto3-events = buildMypyBoto3Package "events" "1.33.0" "sha256-LBBEAvWtvnm2acKx6ox2mQ0uaZroMuOxTmtK4fSVUXc=";

  mypy-boto3-evidently = buildMypyBoto3Package "evidently" "1.33.0" "sha256-ofiGAmmG9meO1agTf96JfEwsFeE38mf7DoMprNOCvSc=";

  mypy-boto3-finspace = buildMypyBoto3Package "finspace" "1.33.0" "sha256-YBRzVfem5DftPDyy4Hhb+XPfmajZq651qJtoMmiPzZY=";

  mypy-boto3-finspace-data = buildMypyBoto3Package "finspace-data" "1.33.0" "sha256-Wps7GUx2h4BD8meQhLQzPuBBDnfPNHeUq+E7MrNTtIw=";

  mypy-boto3-firehose = buildMypyBoto3Package "firehose" "1.33.0" "sha256-wy8knDQOikxD/ne6cpBcYKwUssQLoGGFnyCuAbMrDMU=";

  mypy-boto3-fis = buildMypyBoto3Package "fis" "1.33.0" "sha256-xZeRIBr6Tp+K4UKUjy9M+jU8TQQUyjxCCfVXc7mIo/w=";

  mypy-boto3-fms = buildMypyBoto3Package "fms" "1.33.0" "sha256-wDPsp7QGmRS8pdnd05aliOpEGKoqpdTa7zR3onGEEbw=";

  mypy-boto3-forecast = buildMypyBoto3Package "forecast" "1.33.0" "sha256-RrZhQwn2UAypdaorWbC/zvLMH6IjO7RPio7NEP2vcdU=";

  mypy-boto3-forecastquery = buildMypyBoto3Package "forecastquery" "1.33.0" "sha256-OF1v/GzZHt5457LzWJ+LkG/t4Je3EtiUh2uO84oiqL4=";

  mypy-boto3-frauddetector = buildMypyBoto3Package "frauddetector" "1.33.0" "sha256-H97TX8YI5rcY6qi77VPDmDt7H8fBG3hDIINuKdeOnGc=";

  mypy-boto3-fsx = buildMypyBoto3Package "fsx" "1.33.0" "sha256-fTR76ohKxtqklzjnSGGJ6BdmSB9RHzZcxjskhoI4S7c=";

  mypy-boto3-gamelift = buildMypyBoto3Package "gamelift" "1.33.0" "sha256-1XFimCfGBl3gKTftrVu+6GGeUxzB4Bu7zx2w9Lp9rCM=";

  mypy-boto3-gamesparks = buildMypyBoto3Package "gamesparks" "1.28.36" "sha256-6lQXNJ55FYvkFA14rgJGhRMjBHA3YrOybnsKNecX7So=";

  mypy-boto3-glacier = buildMypyBoto3Package "glacier" "1.33.0" "sha256-01Ezh49UNf70wDJY0q2TRdkVGgZ9iWVzMpVQ0FBC7aE=";

  mypy-boto3-globalaccelerator = buildMypyBoto3Package "globalaccelerator" "1.33.0" "sha256-766QC1uxF2gi0R24SUnPT66NZou6boAO6cPyDM21uFQ=";

  mypy-boto3-glue = buildMypyBoto3Package "glue" "1.33.0" "sha256-FPH1JgnHriCZB9xNjizMguZownrjAN8AA+Du9//Gh2E=";

  mypy-boto3-grafana = buildMypyBoto3Package "grafana" "1.33.0" "sha256-jlmU8liC9NUX7lgt46sgV/Jdp0xgS2X2T0wnX1xU1S4=";

  mypy-boto3-greengrass = buildMypyBoto3Package "greengrass" "1.33.0" "sha256-ZtKGtJcDIipfc5OGQX1QxydRZPZI6D/Hd/YrWmgu6D8=";

  mypy-boto3-greengrassv2 = buildMypyBoto3Package "greengrassv2" "1.33.0" "sha256-wELqoYtB/VazExZILkRqd2SgoUNdUtDn+OpIgWsKUYk=";

  mypy-boto3-groundstation = buildMypyBoto3Package "groundstation" "1.33.0" "sha256-JzBPYdnKHx/ewsOIGgteMrpK3iAYNtoGd34dqoDfnRA=";

  mypy-boto3-guardduty = buildMypyBoto3Package "guardduty" "1.33.0" "sha256-bJrOvWetK0Lwh40TMj2AcK9j9UpFIk2DqaDrgmnr1aA=";

  mypy-boto3-health = buildMypyBoto3Package "health" "1.33.0" "sha256-P/S/2d6qu1Qu5EGDgi3tX7AeZtmgPhIDszC+mA1q94U=";

  mypy-boto3-healthlake = buildMypyBoto3Package "healthlake" "1.33.0" "sha256-fcXpQbayMV6KG/TI2+uuYp26AcMwZGkk/N0n+Cus37o=";

  mypy-boto3-honeycode = buildMypyBoto3Package "honeycode" "1.33.0" "sha256-nPQcYVfhBsQ7D1wgRelQ74W8R4ZQGNteKd+7PghFJJA=";

  mypy-boto3-iam = buildMypyBoto3Package "iam" "1.33.0" "sha256-fmt2NOtOGqjcvGvX4djRV+lTU9PvHGznnz/SlPxWgss=";

  mypy-boto3-identitystore = buildMypyBoto3Package "identitystore" "1.33.0" "sha256-WjNpOX7ewqERT7NTj4hggSbMn0xud0VJHeGKOi9rCZ0=";

  mypy-boto3-imagebuilder = buildMypyBoto3Package "imagebuilder" "1.33.0" "sha256-vseyFnB/ZfR8Ihv3QSbcHw7ly1mHixl2v+2luMWWfCY=";

  mypy-boto3-importexport = buildMypyBoto3Package "importexport" "1.33.0" "sha256-UcnlWJa230onKQ2ywfU9ELCnGk3hGSvXo7enfLXO3fU=";

  mypy-boto3-inspector = buildMypyBoto3Package "inspector" "1.33.0" "sha256-wPYq6HauR/FKWQhOFW6kZ2K9krgbQy861x5fc6cj/Rk=";

  mypy-boto3-inspector2 = buildMypyBoto3Package "inspector2" "1.33.0" "sha256-TQyExlqtCcn2MSlOQM+0leuYQRpAsiug1M17aeMA2v8=";

  mypy-boto3-internetmonitor = buildMypyBoto3Package "internetmonitor" "1.33.0" "sha256-0zgfGDnrGZ5V9ZnPhajuJ5Da4mvrXokyAkwkTJIoSFc=";

  mypy-boto3-iot = buildMypyBoto3Package "iot" "1.33.0" "sha256-ybLNQK6TqTQyOCbh4LDl0fTHMxHT/hFPVrfQDsmM3UE=";

  mypy-boto3-iot-data = buildMypyBoto3Package "iot-data" "1.33.0" "sha256-3Pp4qX9zCcVZu+9cP6w3OoSSwdnxUfDzbta+jMrr9wA=";

  mypy-boto3-iot-jobs-data = buildMypyBoto3Package "iot-jobs-data" "1.33.0" "sha256-2DCo9QUW1HKoKdfHgD+xyRQqIuZ7o7uUXPvY07EZV0g=";

  mypy-boto3-iot-roborunner = buildMypyBoto3Package "iot-roborunner" "1.33.0" "sha256-GXlKkwzNjXJYPzHdI3Uri65/0nBXd+orYvKcWoSeK7c=";

  mypy-boto3-iot1click-devices = buildMypyBoto3Package "iot1click-devices" "1.33.0" "sha256-cQ0OkkCmUUfs+QUvhhAW/KpuavwGafvqdFrY1PzzXbw=";

  mypy-boto3-iot1click-projects = buildMypyBoto3Package "iot1click-projects" "1.33.0" "sha256-l8DLko7HIyeY8VNCyptEEs5eLp1sqy+2BGUitbMcNUM=";

  mypy-boto3-iotanalytics = buildMypyBoto3Package "iotanalytics" "1.33.0" "sha256-OySLO+BwjHWcjXhN0XoT1ORfTblgh+IzJ+n0/5LemrA=";

  mypy-boto3-iotdeviceadvisor = buildMypyBoto3Package "iotdeviceadvisor" "1.33.0" "sha256-eW0eDcwoJGyx8rFpnyYBZDkWlFtEaNRiO+gcVI0nBcY=";

  mypy-boto3-iotevents = buildMypyBoto3Package "iotevents" "1.33.0" "sha256-DV0/RbgvhTWrSGGk10O/9NyEtuf+ApIE3X8/KF2eIr4=";

  mypy-boto3-iotevents-data = buildMypyBoto3Package "iotevents-data" "1.33.0" "sha256-r1g2IkOxMSqNr9QsCLqgEjLn7BxpvqxCyq0AvVgiKQ8=";

  mypy-boto3-iotfleethub = buildMypyBoto3Package "iotfleethub" "1.33.0" "sha256-2k26pPTWBe8N/1bQeWpgJ8en7S9fY3Q5MMpr7aqvoZY=";

  mypy-boto3-iotfleetwise = buildMypyBoto3Package "iotfleetwise" "1.33.0" "sha256-GVpJRoNPfGBrWg93fSG4ZG24kLx+6Mq+YVsQAtgzS1o=";

  mypy-boto3-iotsecuretunneling = buildMypyBoto3Package "iotsecuretunneling" "1.33.0" "sha256-noMig7pdZsXfbEvqKbN8coNdXeW7ka1TNlx+WYiDJk0=";

  mypy-boto3-iotsitewise = buildMypyBoto3Package "iotsitewise" "1.33.0" "sha256-+MIlyAm+43Nnnll2p45xcMJvnzA2bAn1bCP9qxJIRXM=";

  mypy-boto3-iotthingsgraph = buildMypyBoto3Package "iotthingsgraph" "1.33.0" "sha256-PMEe/LRjTfcSLPrZiAZeJKebaweWJw2Xr0GO+PBZBoc=";

  mypy-boto3-iottwinmaker = buildMypyBoto3Package "iottwinmaker" "1.33.0" "sha256-iKuROApGa2q+z+GCgV7ouAC0kHehZFPsRvPBuMwT5Gw=";

  mypy-boto3-iotwireless = buildMypyBoto3Package "iotwireless" "1.33.0" "sha256-g5lodl8v/5YZYlHQnMQBVQZFL5ad1YfXKq/OYfYh57Y=";

  mypy-boto3-ivs = buildMypyBoto3Package "ivs" "1.33.0" "sha256-66gIYLReZzmbqN3V9HJPLJqUEko9foM7BIpojBgdl1c=";

  mypy-boto3-ivs-realtime = buildMypyBoto3Package "ivs-realtime" "1.33.0" "sha256-6Y9WnlSkgoD44QwzR9RebkkMQD36EhiZ83jk9Pnwwdc=";

  mypy-boto3-ivschat = buildMypyBoto3Package "ivschat" "1.33.0" "sha256-kcfUbJNRK8bG5yKrQ6oSWrTpu38CI9LRxXvEahYScc4=";

  mypy-boto3-kafka = buildMypyBoto3Package "kafka" "1.33.0" "sha256-YwM+ebNi8hWLlpt5rjiw6Vqs3UMTCvmpb1CWOufW6TQ=";

  mypy-boto3-kafkaconnect = buildMypyBoto3Package "kafkaconnect" "1.33.0" "sha256-dwj2qQAWNgAbYafhnkN+EvFDkkgEu07lVlYJ/gDZZes=";

  mypy-boto3-kendra = buildMypyBoto3Package "kendra" "1.33.0" "sha256-qHfH4AqYPTu2pxT9eRfd/5bcAkNEpT6anrlCNVlbd98=";

  mypy-boto3-kendra-ranking = buildMypyBoto3Package "kendra-ranking" "1.33.0" "sha256-5cNnC6fTZ5bBdv37pW1B7T5BEDG//srFIGkZgYKUvQw=";

  mypy-boto3-keyspaces = buildMypyBoto3Package "keyspaces" "1.33.0" "sha256-B3TRxDV9rjs++M8h9a+jXfQWGP+EalKIUwPVePRChf0=";

  mypy-boto3-kinesis = buildMypyBoto3Package "kinesis" "1.33.0" "sha256-zub0pEfwm8GB7zHRGtbylpTFdUwJXhY391xEH8qYpE8=";

  mypy-boto3-kinesis-video-archived-media = buildMypyBoto3Package "kinesis-video-archived-media" "1.33.0" "sha256-kEAXky62xtIUeCzrqu9ZrK9TiV6yJHkM539iGdaMgzU=";

  mypy-boto3-kinesis-video-media = buildMypyBoto3Package "kinesis-video-media" "1.33.0" "sha256-bVo8NBi2h44/1CVewfBJKqgeus0g7F8N4tw/TenctM8=";

  mypy-boto3-kinesis-video-signaling = buildMypyBoto3Package "kinesis-video-signaling" "1.33.0" "sha256-zc2L2M4FivEG3ngp2Jbd19wbRsHZgRUJ+9MFGZlx6oQ=";

  mypy-boto3-kinesis-video-webrtc-storage = buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.33.0" "sha256-C6tp7/vJ2lCAV2e91U9cDfMGcJBBTY0oWZtgyWRLEvI=";

  mypy-boto3-kinesisanalytics = buildMypyBoto3Package "kinesisanalytics" "1.33.0" "sha256-0zg7wcbado7xu+CRsxaEErycUsO54SCw7IsXiYqkgaQ=";

  mypy-boto3-kinesisanalyticsv2 = buildMypyBoto3Package "kinesisanalyticsv2" "1.33.0" "sha256-fJ/tadSlvq64oqjqt1epuBBSHjer+YbIIIdL5xbcS3I=";

  mypy-boto3-kinesisvideo = buildMypyBoto3Package "kinesisvideo" "1.33.0" "sha256-78300PfV5TPI0hZQh1tCFjedq3htKSGzyJ4uWEIncsc=";

  mypy-boto3-kms = buildMypyBoto3Package "kms" "1.33.0" "sha256-nQCdPjydIXhfyxD8cd4d6JgA4zhstpJSLKkSVKh+2gM=";

  mypy-boto3-lakeformation = buildMypyBoto3Package "lakeformation" "1.33.0" "sha256-8Y9t0VeNWsVOmCR/SdUIBHnDvjkoWy5bw2RjSxuSw7Q=";

  mypy-boto3-lambda = buildMypyBoto3Package "lambda" "1.33.0" "sha256-vqwMtLlPg6REJC2xb2AUBb37bBWAjCxScgIk2Qfnr0A=";

  mypy-boto3-lex-models = buildMypyBoto3Package "lex-models" "1.33.0" "sha256-PUgJnDXfy3tHZc08HTlRlufnSLJbSLHD1GLTJX4HnC8=";

  mypy-boto3-lex-runtime = buildMypyBoto3Package "lex-runtime" "1.33.0" "sha256-8HTRPL3CeH3tdq/N0+OWO5k9sqf/32iPDsqkMjGEGUI=";

  mypy-boto3-lexv2-models = buildMypyBoto3Package "lexv2-models" "1.33.0" "sha256-YpmCUj2ODUX1FHr5TDVmPxE3/58wskLX1GtVwuVd4UI=";

  mypy-boto3-lexv2-runtime = buildMypyBoto3Package "lexv2-runtime" "1.33.0" "sha256-9+R8J3Vy6+pM+wel+LhSXjlPpkdTTw6sGjdd/RKhI3Y=";

  mypy-boto3-license-manager = buildMypyBoto3Package "license-manager" "1.33.0" "sha256-pIzCQAn6H97JMnH7FBXHSpihnZHSzdXwNcJpLGk3/ws=";

  mypy-boto3-license-manager-linux-subscriptions = buildMypyBoto3Package "license-manager-linux-subscriptions" "1.33.0" "sha256-z37qcv32occf3LKamxEJXSxjSAtIX998mnWl2ARjDsM=";

  mypy-boto3-license-manager-user-subscriptions = buildMypyBoto3Package "license-manager-user-subscriptions" "1.33.0" "sha256-HwNmdaP6309iCUQj1/auczwB3qu6JbZcBaIRIgACCnw=";

  mypy-boto3-lightsail = buildMypyBoto3Package "lightsail" "1.33.0" "sha256-ArY3xYDsJ49TTnkvpaEYzWaISt22VaDF6BBlViElGBk=";

  mypy-boto3-location = buildMypyBoto3Package "location" "1.33.0" "sha256-erlU4iV29mUx9hm6rI0PIDQv88QQkZ7CTVQqas3GIK4=";

  mypy-boto3-logs = buildMypyBoto3Package "logs" "1.33.0" "sha256-YHUgeW9sqmnl6SHrSJmjcPan7Qx+vcG/A5a+wkr4gPI=";

  mypy-boto3-lookoutequipment = buildMypyBoto3Package "lookoutequipment" "1.33.0" "sha256-MTZmdiv6sdWI5VaJ76ehlmZn95Yn98OD4vlLEHgJL2g=";

  mypy-boto3-lookoutmetrics = buildMypyBoto3Package "lookoutmetrics" "1.33.0" "sha256-r0hkRsM8pBLz7Avr4BoJu3nCT1aSBEwqgVE3LCZB9OA=";

  mypy-boto3-lookoutvision = buildMypyBoto3Package "lookoutvision" "1.33.0" "sha256-R55LCcvLTNuL1ldp2E0ocD/tBWvO3K6vhXQZwJIyFRQ=";

  mypy-boto3-m2 = buildMypyBoto3Package "m2" "1.33.0" "sha256-TNbkHPjRwo9JTkUrbmHl89OP0OnqE6IBQkrpBsulxE8=";

  mypy-boto3-machinelearning = buildMypyBoto3Package "machinelearning" "1.33.0" "sha256-HndoCwclr0r0Efj0KS+lcjWn4JSTV/5hilMhzYdDbfU=";

  mypy-boto3-macie = buildMypyBoto3Package "macie" "1.28.36" "sha256-T7zd6G5Z4fz1/ZiCOwf+kWbXWCy35JaE3f2OUpWGNpE=";

  mypy-boto3-macie2 = buildMypyBoto3Package "macie2" "1.33.0" "sha256-H/xDY6kp8nKQNfAWtwtlcaiLtzcihKnVKesfW09lkeU=";

  mypy-boto3-managedblockchain = buildMypyBoto3Package "managedblockchain" "1.33.0" "sha256-tjv51JiiZfjZhQUc+8AwUqPqu2feTNZdn6nRcm/RDtw=";

  mypy-boto3-managedblockchain-query = buildMypyBoto3Package "managedblockchain-query" "1.33.0" "sha256-jZwYm+rYczq2PiML7thRqgn2ud5fP4j2gkxje2CmiHY=";

  mypy-boto3-marketplace-catalog = buildMypyBoto3Package "marketplace-catalog" "1.33.0" "sha256-ye9S1wPBfgc4FbkKpfi1WzR4CJn9GE6mhrxbE8n5z+w=";

  mypy-boto3-marketplace-entitlement = buildMypyBoto3Package "marketplace-entitlement" "1.33.0" "sha256-uUdFqAtq/uLJ8WuG9Kp4XtN5nQS35pxTb4S2OjAqn2w=";

  mypy-boto3-marketplacecommerceanalytics = buildMypyBoto3Package "marketplacecommerceanalytics" "1.33.0" "sha256-6DVPmJHDc7NkrWQufzse/F1nghbMaUWxhr5UPBq+MNY=";

  mypy-boto3-mediaconnect = buildMypyBoto3Package "mediaconnect" "1.33.0" "sha256-dx2tLLmihzZpcpP8MkK7cAUqnKtZB4FENUKByaw0arA=";

  mypy-boto3-mediaconvert = buildMypyBoto3Package "mediaconvert" "1.33.0" "sha256-d4v+vtVNYqx0tGkNJqp3NMKFc5vsnqSRCs+v/VRx480=";

  mypy-boto3-medialive = buildMypyBoto3Package "medialive" "1.33.0" "sha256-GBkjE0qsw2CB7C26HyGZtj7q7Ll/ZRkybG8ieWUWPUw=";

  mypy-boto3-mediapackage = buildMypyBoto3Package "mediapackage" "1.33.0" "sha256-6c21ah2h/dSA99HrYMhyDAmA0g4pab6euqZ6bHCLavo=";

  mypy-boto3-mediapackage-vod = buildMypyBoto3Package "mediapackage-vod" "1.33.0" "sha256-0iDa1wAxNTunibq6upy9sO2EDVNUZe4BZu6uAnIH0z4=";

  mypy-boto3-mediapackagev2 = buildMypyBoto3Package "mediapackagev2" "1.33.0" "sha256-D6F1rUwb3NC71r4xSy4C1s873Zapod+z+KK4M0JD/qM=";

  mypy-boto3-mediastore = buildMypyBoto3Package "mediastore" "1.33.0" "sha256-lPcHVhxQFa3/RQeXtXpthzVMGYxMSSrq8fSJCIMOEVQ=";

  mypy-boto3-mediastore-data = buildMypyBoto3Package "mediastore-data" "1.33.0" "sha256-ATbzeBpKdRsLZNPc/LunbV3vtk2MwbiE/3Rd3dK1bGw=";

  mypy-boto3-mediatailor = buildMypyBoto3Package "mediatailor" "1.33.0" "sha256-ChpZp3x6RD0A2x29b8oYCOJ1B5ZSAsKR+ppJ7ClH3XM=";

  mypy-boto3-medical-imaging = buildMypyBoto3Package "medical-imaging" "1.33.0" "sha256-RwrnUf+oMvTLoB92Hw4UUYhTF3uspYeMabLF2wN1xiU=";

  mypy-boto3-memorydb = buildMypyBoto3Package "memorydb" "1.33.0" "sha256-P//hCRj4DA/KU/a9T72pbxzASx5/ZX4GxgIbyMSdUlY=";

  mypy-boto3-meteringmarketplace = buildMypyBoto3Package "meteringmarketplace" "1.33.0" "sha256-K/+TL2G/cA8nJ9z7KXMolco/qnvZmpmwSga1RMOfFkQ=";

  mypy-boto3-mgh = buildMypyBoto3Package "mgh" "1.33.0" "sha256-cUjW8WKwjteGlw2NyHzCCxuBd7iVxS12KkR1EnaAoa8=";

  mypy-boto3-mgn = buildMypyBoto3Package "mgn" "1.33.0" "sha256-lUJtRzW5UAjl1LXkZHWg1WlUpxjasmgo33lGRw9udQc=";

  mypy-boto3-migration-hub-refactor-spaces = buildMypyBoto3Package "migration-hub-refactor-spaces" "1.33.0" "sha256-FM0tshcFNXf8Ms/iHh5P8T5m9FxP1aVkp+Kjctr/Hwg=";

  mypy-boto3-migrationhub-config = buildMypyBoto3Package "migrationhub-config" "1.33.0" "sha256-kHp3Tjk7XwXI7Zb6Oyjbpn6mdDreidkjZ7E1mqPtGn8=";

  mypy-boto3-migrationhuborchestrator = buildMypyBoto3Package "migrationhuborchestrator" "1.33.0" "sha256-DwQZO4+j8KedJuyik2pQdFYdSd0JJAw2/5cZ7xFp/OE=";

  mypy-boto3-migrationhubstrategy = buildMypyBoto3Package "migrationhubstrategy" "1.33.0" "sha256-z+ouYb9EZzz7wjA5bZro/G+o/NRMYcIHnaeTXx2tWS8=";

  mypy-boto3-mobile = buildMypyBoto3Package "mobile" "1.33.0" "sha256-URX3lEpb5Dc1fw4H8B9tlBRG7GEjPJookU4uyI8evGo=";

  mypy-boto3-mq = buildMypyBoto3Package "mq" "1.33.0" "sha256-AQLeF4t5dc6ggH4g4DppdULhU5CKAaQqXWAEvc9cBT4=";

  mypy-boto3-mturk = buildMypyBoto3Package "mturk" "1.33.0" "sha256-x9bBvryI5u4fgpmjFTpXd2sToP3G3OwNs1RXKgLqbH8=";

  mypy-boto3-mwaa = buildMypyBoto3Package "mwaa" "1.33.0" "sha256-8ugvyQpgi/M4aZZmV98cB0wTIjJkwp3Uxnw3oWu7ldI=";

  mypy-boto3-neptune = buildMypyBoto3Package "neptune" "1.33.0" "sha256-PJdMZujxddavi9qDC1AGy+kaXPSwP6HPwslwsye+kBc=";

  mypy-boto3-neptunedata = buildMypyBoto3Package "neptunedata" "1.33.0" "sha256-N731oAubylvxdhHkPVhYsSni/1/GyQgUe/Q1owcqs7s=";

  mypy-boto3-network-firewall = buildMypyBoto3Package "network-firewall" "1.33.0" "sha256-FhtuWhOJOYVTKkh9qVYEGVVcz0npD2UJwbdxzZYj7pA=";

  mypy-boto3-networkmanager = buildMypyBoto3Package "networkmanager" "1.33.0" "sha256-ODut19IQZ30DlhkOvXa0yeU8LN82BXf0jLS5r7gELKs=";

  mypy-boto3-nimble = buildMypyBoto3Package "nimble" "1.33.0" "sha256-mivgmoJ0UOFE7hO+kZ58l3UlzYYePQBYgKufIyeqqYc=";

  mypy-boto3-oam = buildMypyBoto3Package "oam" "1.33.0" "sha256-UvOox6pd/SVsLPYoSfyOrga3A/xKeesLGB3XQJpJ74k=";

  mypy-boto3-omics = buildMypyBoto3Package "omics" "1.33.0" "sha256-+IKxv7RV3O/SE4Wbu/vK/ILdQSVZgcVpGjyssUivDLA=";

  mypy-boto3-opensearch = buildMypyBoto3Package "opensearch" "1.33.0" "sha256-UBQKDr1Ki4/7hv26tQt4LVl4WmwTJjEdvAosbU+tbTU=";

  mypy-boto3-opensearchserverless = buildMypyBoto3Package "opensearchserverless" "1.33.0" "sha256-BCX9Hn5zi9hvrYfwNBzJ+ZYBM10/pAyFxg/c6DPXkzU=";

  mypy-boto3-opsworks = buildMypyBoto3Package "opsworks" "1.33.0" "sha256-1wNaezlG9q9h3PxxpSiNqVaG+7NE4xyLSyscAwZgGTY=";

  mypy-boto3-opsworkscm = buildMypyBoto3Package "opsworkscm" "1.33.0" "sha256-9aaBhfj0jgW/SSVTEfnrQ+aFUmrRUH0QTNeb60ID/5Q=";

  mypy-boto3-organizations = buildMypyBoto3Package "organizations" "1.33.0" "sha256-CaUFowv10Ytj4c1Cgt2jvrtgLh3nakbMxyrfKYV5//g=";

  mypy-boto3-osis = buildMypyBoto3Package "osis" "1.33.0" "sha256-8upYKP1B7FiQ6GkUh9wgedHWra9CVnTLf9nSGExi4Tc=";

  mypy-boto3-outposts = buildMypyBoto3Package "outposts" "1.33.0" "sha256-hRHvlNlIW9xnXCRyB9J0seowO6hMkKSHhH9em/zhjRY=";

  mypy-boto3-panorama = buildMypyBoto3Package "panorama" "1.33.0" "sha256-1thhpvAzDWl5aWzkAT5+VoWfKCU5PnZxxxiyiMjJ+YE=";

  mypy-boto3-payment-cryptography = buildMypyBoto3Package "payment-cryptography" "1.33.0" "sha256-9IfdLZJrc/07tCB/Zw9p2aBfi0Wn28YpRrRBS/2JDeg=";

  mypy-boto3-payment-cryptography-data = buildMypyBoto3Package "payment-cryptography-data" "1.33.0" "sha256-M905qk0RYwBA7ps3owD1XoH7Yo78Gr5CQQ7Lm78oLGU=";

  mypy-boto3-pca-connector-ad = buildMypyBoto3Package "pca-connector-ad" "1.33.0" "sha256-Lo307Al/6KeDuXI0uXv9YaIt7N8f98ecnm7UvcqXTy8=";

  mypy-boto3-personalize = buildMypyBoto3Package "personalize" "1.33.0" "sha256-Xdxn78a/fJ9HpVAPfIvI/WEwWfpP5I9DBFCouNM+yx4=";

  mypy-boto3-personalize-events = buildMypyBoto3Package "personalize-events" "1.33.0" "sha256-qxOtdxPdMsUb3AF4RxS71rQR+yNZ/bEU5AVbdCnzMP8=";

  mypy-boto3-personalize-runtime = buildMypyBoto3Package "personalize-runtime" "1.33.0" "sha256-nPsZi1PNB114A/PF54bH+AaBQwHFXVWGlU8j2g/5GIo=";

  mypy-boto3-pi = buildMypyBoto3Package "pi" "1.33.0" "sha256-XSJHfOEUBJr+Ma6cl60v28nqWUBWDq+Qo57ib0XcMPo=";

  mypy-boto3-pinpoint = buildMypyBoto3Package "pinpoint" "1.33.0" "sha256-JtbvxlgMqGkpe1A9iJ/75yKMO1UwezscJGTmdB79CwQ=";

  mypy-boto3-pinpoint-email = buildMypyBoto3Package "pinpoint-email" "1.33.0" "sha256-UI+xK8uW7QsFIMY8WgzGiimk09M/aEM2LeZGwnYdsGo=";

  mypy-boto3-pinpoint-sms-voice = buildMypyBoto3Package "pinpoint-sms-voice" "1.33.0" "sha256-1rOzAXWJgpUzXCnnJbGT1BsVU5Nvamx38F93UhD9eOo=";

  mypy-boto3-pinpoint-sms-voice-v2 = buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.33.0" "sha256-I/X/ss73SZ+vN+RhYq17MOR3e6V8hkWSSEi7aDvNMaM=";

  mypy-boto3-pipes = buildMypyBoto3Package "pipes" "1.33.0" "sha256-T3xFxUfzUVwBlL94lzk90X2lpKrdm+KfmyClusgOrIE=";

  mypy-boto3-polly = buildMypyBoto3Package "polly" "1.33.0" "sha256-rxPlhb8KKxg3nTyZuoqqyY+GggSSrT8gLgUksqxeJLk=";

  mypy-boto3-pricing = buildMypyBoto3Package "pricing" "1.33.0" "sha256-CT9TCmwAEbxb4/y9Cg/pEDklti31AuAXSqC/sJL4APw=";

  mypy-boto3-privatenetworks = buildMypyBoto3Package "privatenetworks" "1.33.0" "sha256-+oJe6OMaBFm9BLXdEm2ka7hQt4Ljre5NSBpCpXtqco8=";

  mypy-boto3-proton = buildMypyBoto3Package "proton" "1.33.0" "sha256-ntEvse5U66ab3wkNJeId0mH2rbpYHn4w1L/r5pBmlhY=";

  mypy-boto3-qldb = buildMypyBoto3Package "qldb" "1.33.0" "sha256-F1QY3bB8FnjIBgRJy/b0QXfMcDRxa0wobl/+hr8VSl4=";

  mypy-boto3-qldb-session = buildMypyBoto3Package "qldb-session" "1.33.0" "sha256-UL8WtdlVsMxZu2wU/xC3mMS0NsOgw9MCDblIYlGv4ew=";

  mypy-boto3-quicksight = buildMypyBoto3Package "quicksight" "1.33.0" "sha256-hKD1G17c+IG1FVqvkdCmS+XfTLtDKJFfNoqBMC0Wm0I=";

  mypy-boto3-ram = buildMypyBoto3Package "ram" "1.33.0" "sha256-fbuo70E/H+EnJOgGjYBpMLwr8OgvU32QoLaR9q8OZUU=";

  mypy-boto3-rbin = buildMypyBoto3Package "rbin" "1.33.0" "sha256-dtOVbyLlE63ZKSVZwlYkjgK0Tft5Re95yIRkurrnRXU=";

  mypy-boto3-rds = buildMypyBoto3Package "rds" "1.33.0" "sha256-KlDkCqRzs05mUWcqQjOHO1+vvkIhjDOvJ6js+FcekWk=";

  mypy-boto3-rds-data = buildMypyBoto3Package "rds-data" "1.33.0" "sha256-ND5mLqGQlLNbTUqsGDy9LnFIDNL/piYv7P7MZuYjR24=";

  mypy-boto3-redshift = buildMypyBoto3Package "redshift" "1.33.0" "sha256-ayvQXqTu6MQyoifL+7wokW1mneD33BNtiwiNNSjQGhA=";

  mypy-boto3-redshift-data = buildMypyBoto3Package "redshift-data" "1.33.0" "sha256-DyyLQrbqQGvjguHHyF/wi1jNOMkw/bhEqvvbP9ABOeM=";

  mypy-boto3-redshift-serverless = buildMypyBoto3Package "redshift-serverless" "1.33.0" "sha256-rjOGhRFap1fiQKgF7Z56ltq3V+Z39tpler6UFhPGozE=";

  mypy-boto3-rekognition = buildMypyBoto3Package "rekognition" "1.33.0" "sha256-i+RvqZwdCBds+J4rEE7WwGvlimIabFT/QBwV4enK03A=";

  mypy-boto3-resiliencehub = buildMypyBoto3Package "resiliencehub" "1.33.0" "sha256-UC22j0SRxmhQZl7nUX/V3B8KwMTVARHqkKO+S1NyjzU=";

  mypy-boto3-resource-explorer-2 = buildMypyBoto3Package "resource-explorer-2" "1.33.0" "sha256-n2iKbDn31upQ1b5Kwv3nw3pR6DAd6Zoo6Gyy/vLwC2E=";

  mypy-boto3-resource-groups = buildMypyBoto3Package "resource-groups" "1.33.0" "sha256-6ueWCB5LNmsBtg3qLligNU67YJIMeXZUqgzD/UiD6p8=";

  mypy-boto3-resourcegroupstaggingapi = buildMypyBoto3Package "resourcegroupstaggingapi" "1.33.0" "sha256-uTKy2n/VGyJECrC+r4KmPpijypJZI+YpjUJIaCzocxs=";

  mypy-boto3-robomaker = buildMypyBoto3Package "robomaker" "1.33.0" "sha256-PAkcxkWqOFFFYJKcuhGg+V7Fpy0DO8ZbtWi91dxwRTQ=";

  mypy-boto3-rolesanywhere = buildMypyBoto3Package "rolesanywhere" "1.33.0" "sha256-OCylaHsT5/70KEHa/MR3VpgX0Tca+9ajhxxFvm/52y4=";

  mypy-boto3-route53 = buildMypyBoto3Package "route53" "1.33.0" "sha256-TN0c2fnBFZs1teYTK47aS2aSIJsfTyykEG+u6AIEq08=";

  mypy-boto3-route53-recovery-cluster = buildMypyBoto3Package "route53-recovery-cluster" "1.33.0" "sha256-xgDxR2NVl1tIywv62qtQVMWwVl1OOqpNjHKVgQRNiIA=";

  mypy-boto3-route53-recovery-control-config = buildMypyBoto3Package "route53-recovery-control-config" "1.33.0" "sha256-3ei5cXJQXdn8enEajUuZx6Cdr7muZu8jj70HnTNAcbY=";

  mypy-boto3-route53-recovery-readiness = buildMypyBoto3Package "route53-recovery-readiness" "1.33.0" "sha256-G7Gxq11J/vP9yX58B2PLzoPpt2auor3cjFDCwyKZ6ys=";

  mypy-boto3-route53domains = buildMypyBoto3Package "route53domains" "1.33.0" "sha256-IIZ31f3mRlpjcmPDZ3A32sr6lTowbgV2ZXZa6eiR+ao=";

  mypy-boto3-route53resolver = buildMypyBoto3Package "route53resolver" "1.33.0" "sha256-7Xwoqrqel7ra/GszrB6LM5xHi/nUS9e46YuiHj4a+uI=";

  mypy-boto3-rum = buildMypyBoto3Package "rum" "1.33.0" "sha256-rjTTL6bv/K4L2al5U7ocHFbNIoDI9ddtDKwuglSY20M=";

  mypy-boto3-s3 = buildMypyBoto3Package "s3" "1.33.0" "sha256-O46rgr2L/RzKuMB327njJr55WbQLb0hb5Xaz1RNd3ZE=";

  mypy-boto3-s3control = buildMypyBoto3Package "s3control" "1.33.0" "sha256-f9iCCJeRTWJuxseojW9uifSYCykVzp0TkLl+Y04BAqM=";

  mypy-boto3-s3outposts = buildMypyBoto3Package "s3outposts" "1.33.0" "sha256-6pNmhC3DGO1LywdB5WoItSexmu3vXLphI22Q7AA+VFQ=";

  mypy-boto3-sagemaker = buildMypyBoto3Package "sagemaker" "1.33.0" "sha256-3h/cL+zIk4lnqi1bPvynHxEkENb0x91a8VRiVnti6GA=";

  mypy-boto3-sagemaker-a2i-runtime = buildMypyBoto3Package "sagemaker-a2i-runtime" "1.33.0" "sha256-f6gy+UftA5pbCKREX9GQfgWZHiiliNUE9HwjdUdSfXU=";

  mypy-boto3-sagemaker-edge = buildMypyBoto3Package "sagemaker-edge" "1.33.0" "sha256-EDVAUidBT2RL/Pw5GtkHhY1o5acpUgHPcb8VAoA3HHc=";

  mypy-boto3-sagemaker-featurestore-runtime = buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.33.0" "sha256-ARyYSoE5vYQx9D3QtGwGXcdjGBl1syrClfiyoYUCSlE=";

  mypy-boto3-sagemaker-geospatial = buildMypyBoto3Package "sagemaker-geospatial" "1.33.0" "sha256-qFAF+i//ndB7xVgicFNS6pLwZbrOkfL/S8TresMUF88=";

  mypy-boto3-sagemaker-metrics = buildMypyBoto3Package "sagemaker-metrics" "1.33.0" "sha256-p+OhIn4qrQ4P44N4XH1X7Xfkc3zTVMKlJjPqJ6F8ntc=";

  mypy-boto3-sagemaker-runtime = buildMypyBoto3Package "sagemaker-runtime" "1.33.0" "sha256-OtdeDVyr9YrVxtVoIvdbIcbL890XBZq75ZW+GtYW4cc=";

  mypy-boto3-savingsplans = buildMypyBoto3Package "savingsplans" "1.33.0" "sha256-5msijGns608Yhkf19/hkQSlU1R15Cz84DkaqisnhzPM=";

  mypy-boto3-scheduler = buildMypyBoto3Package "scheduler" "1.33.0" "sha256-XQNvDHADKSW4H2djsnr1KCeTsHrrV0iAsPg3LTqKk2g=";

  mypy-boto3-schemas = buildMypyBoto3Package "schemas" "1.33.0" "sha256-3xGpPsWwXT7uU7y/a/qTP6P18o1fGavfoy2TgPmAThI=";

  mypy-boto3-sdb = buildMypyBoto3Package "sdb" "1.33.0" "sha256-PR9BBaFiN1XBsQGW1yyNyAtZAVu9Vs1e3V3U+7RWdDI=";

  mypy-boto3-secretsmanager = buildMypyBoto3Package "secretsmanager" "1.33.0" "sha256-6nZeeZiGiaLPa6kwdmaqijeE9xWzcbj968t2lPTpK5o=";

  mypy-boto3-securityhub = buildMypyBoto3Package "securityhub" "1.33.0" "sha256-NiBb5+8qXkguB0jgfvLuIJ4KP2a4dRIT1PpbfOCmm+U=";

  mypy-boto3-securitylake = buildMypyBoto3Package "securitylake" "1.33.0" "sha256-y0d9dWIxM+3Q76NNL+zTLh/94W6ckTqa5EQ7ybeTLvQ=";

  mypy-boto3-serverlessrepo = buildMypyBoto3Package "serverlessrepo" "1.33.0" "sha256-LEwYGhI687xCYTd8/gD1OCsJQqYE+6E1iYfc9IW98D8=";

  mypy-boto3-service-quotas = buildMypyBoto3Package "service-quotas" "1.33.0" "sha256-aiUaeMbUZhXO4xwzHKqq34UoLGamxY8ScctNJYAfME0=";

  mypy-boto3-servicecatalog = buildMypyBoto3Package "servicecatalog" "1.33.0" "sha256-CcqYyundv85gm1ldNcJD6CP3NuLoxOlCDtcb9O1GRCw=";

  mypy-boto3-servicecatalog-appregistry = buildMypyBoto3Package "servicecatalog-appregistry" "1.33.0" "sha256-aDB5nDIate3iPsJj/R+nHXIn93s+aS1jEO681soCU1I=";

  mypy-boto3-servicediscovery = buildMypyBoto3Package "servicediscovery" "1.33.0" "sha256-7L2BVq4mpS+hpfSaJI7kP3JIY5HvkvIC9iG/SN1En/k=";

  mypy-boto3-ses = buildMypyBoto3Package "ses" "1.33.0" "sha256-lqQXMviH4mGFxNHOpt6QSivj7oY7OFpqEuBvP0rgo/4=";

  mypy-boto3-sesv2 = buildMypyBoto3Package "sesv2" "1.33.0" "sha256-eUDLuGa64FsuCdthyxQE/Qn5rwIp0zec7MOjOefLE/c=";

  mypy-boto3-shield = buildMypyBoto3Package "shield" "1.33.0" "sha256-YRdKHn5rsvDgnb943Ij1KnofrbRd4pU4TdqQdHP3Xvk=";

  mypy-boto3-signer = buildMypyBoto3Package "signer" "1.33.0" "sha256-S1W9NySnVEpJg38R8hfFSig3TX/trVkpTxE9ZSUGcCU=";

  mypy-boto3-simspaceweaver = buildMypyBoto3Package "simspaceweaver" "1.33.0" "sha256-UZ3zUzYQnhRinS1DgJ84k8+r5gYOE6kCl3SVL/XZy1o=";

  mypy-boto3-sms = buildMypyBoto3Package "sms" "1.33.0" "sha256-rVfUGYJdwzhmuMafNCyHS1juSQKIqnqow0FtaJvDOt0=";

  mypy-boto3-sms-voice = buildMypyBoto3Package "sms-voice" "1.33.0" "sha256-zYeq5fDM+cf+h0XUJQrblYPUEZPJHMfT3xVzCityDjo=";

  mypy-boto3-snow-device-management = buildMypyBoto3Package "snow-device-management" "1.33.0" "sha256-OwhIB0rTJj/OonLCVPLb+IT00xHEbknyDIK+pNqe9s4=";

  mypy-boto3-snowball = buildMypyBoto3Package "snowball" "1.33.0" "sha256-LSSae0TvB4ugThF26dky3mVgn7d0LbH3RxRrO5aga/I=";

  mypy-boto3-sns = buildMypyBoto3Package "sns" "1.33.0" "sha256-5PegpJ1neJ/R1zXVj17zW6S4Kq8EIls0GYGEUr+dQC4=";

  mypy-boto3-sqs = buildMypyBoto3Package "sqs" "1.33.0" "sha256-gfSDjoHLsMCIoQ4oeSL99qPzF8urZkeZOrnb1WfA6Ps=";

  mypy-boto3-ssm = buildMypyBoto3Package "ssm" "1.33.0" "sha256-zPinrGSrOB/I+VZqmW4AMiC4HVcV7RKsSX/lGwYxJSk=";

  mypy-boto3-ssm-contacts = buildMypyBoto3Package "ssm-contacts" "1.33.0" "sha256-yY2RKQIb31DAqE03sj+nUAEENSmfmfPtw0TjipI0hhk=";

  mypy-boto3-ssm-incidents = buildMypyBoto3Package "ssm-incidents" "1.33.0" "sha256-GJFqXklw/6LBN29Rq3v3+ZQf29v0bb0RcgZa7LCzFJU=";

  mypy-boto3-ssm-sap = buildMypyBoto3Package "ssm-sap" "1.33.0" "sha256-jyMEnnc3yKxc+QnhfXaDLx6Gv8zWK2QdMFz/1ETShig=";

  mypy-boto3-sso = buildMypyBoto3Package "sso" "1.33.0" "sha256-0AE79T+no8I85LcUDaJu6mhU3HErmW7uHZliFY9TCC8=";

  mypy-boto3-sso-admin = buildMypyBoto3Package "sso-admin" "1.33.0" "sha256-Ita7xWlUlGkV4+THIfbV+NpwTjINg2sGLaFdYtxqJYg=";

  mypy-boto3-sso-oidc = buildMypyBoto3Package "sso-oidc" "1.33.0" "sha256-dRXHaCSlqZnw6ucYZfTMcynwiBBuoJR1KnCtcECvQug=";

  mypy-boto3-stepfunctions = buildMypyBoto3Package "stepfunctions" "1.33.0" "sha256-CdmlILqHDjaNv/xIdxdFkIyy8MQn+bP6/1zlNxmpY40=";

  mypy-boto3-storagegateway = buildMypyBoto3Package "storagegateway" "1.33.0" "sha256-9DxC+UNQtLUuw4XopRCH7hUFqrzQ/VpsdMRGpfaApxU=";

  mypy-boto3-sts = buildMypyBoto3Package "sts" "1.33.0" "sha256-4IMl0XJ7k0YWoL/N6ME6M0GnnndUii2cPw/H/C4UijM=";

  mypy-boto3-support = buildMypyBoto3Package "support" "1.33.0" "sha256-vlPxisq+A37anbGD2/CqbLkl7APTw1ykofxSXm8gigM=";

  mypy-boto3-support-app = buildMypyBoto3Package "support-app" "1.33.0" "sha256-DuP17/pOEBiQF9sGWd34JXZwprYyoecanphXnLSxXnc=";

  mypy-boto3-swf = buildMypyBoto3Package "swf" "1.33.0" "sha256-g6YeCNjUn5nqpjt3LxZoC26Q9fqt37g9KVXOBG3Kfp8=";

  mypy-boto3-synthetics = buildMypyBoto3Package "synthetics" "1.33.0" "sha256-ej/Bxd9BnsBocaZqekmSuDtnMP9mzPX1QlFCHHCD8sM=";

  mypy-boto3-textract = buildMypyBoto3Package "textract" "1.33.0" "sha256-li0px8Q/y3YtGFXIN93f4dnEQF6Ym6xDrO0hKSZjCOk=";

  mypy-boto3-timestream-query = buildMypyBoto3Package "timestream-query" "1.33.0" "sha256-zk0AXRH+I9ITOpjfYMCS9olJH3BF+kc312u9KersvIQ=";

  mypy-boto3-timestream-write = buildMypyBoto3Package "timestream-write" "1.33.0" "sha256-2Kolw+CmsMDtjJMuY8kjy0XuCmdOu16WmDJFMLjUoPs=";

  mypy-boto3-tnb = buildMypyBoto3Package "tnb" "1.33.0" "sha256-z5rPVAy06qQ5WGOJKQYyy6NVvcGyR709A2EZGDDd1S0=";

  mypy-boto3-transcribe = buildMypyBoto3Package "transcribe" "1.33.0" "sha256-iflxQRk7e7tzh2qj8quJxaris+8lmyaOFeXmG7VS0gk=";

  mypy-boto3-transfer = buildMypyBoto3Package "transfer" "1.33.0" "sha256-JDiD98A/Vfn4qv3lYoQo/mUQ3RxYiq1kl75j4ME5Mqo=";

  mypy-boto3-translate = buildMypyBoto3Package "translate" "1.33.0" "sha256-td3QHxympQnJbM5bBzt1ggSo7S5jyO3y7hnwOmuGM8Y=";

  mypy-boto3-verifiedpermissions = buildMypyBoto3Package "verifiedpermissions" "1.33.0" "sha256-uz9KloAWThUxBj5cyoji4A/1P/jH/0tYq3DTfyd+pmw=";

  mypy-boto3-voice-id = buildMypyBoto3Package "voice-id" "1.33.0" "sha256-7ypwaUuxi5A33zV5CgbQYSaCFiY3r1VgZbN06SpmwMk=";

  mypy-boto3-vpc-lattice = buildMypyBoto3Package "vpc-lattice" "1.33.0" "sha256-nutxvGkImauWfAigsvJyb5Qqzji4VjQIYwaqfhKyaQY=";

  mypy-boto3-waf = buildMypyBoto3Package "waf" "1.33.0" "sha256-Xv7RDeKMiD4AO69sR/KBeP2rnDAidYYUjJuQV0ZRAEI=";

  mypy-boto3-waf-regional = buildMypyBoto3Package "waf-regional" "1.33.0" "sha256-M8mZwqWRbzUe/xQxbG+lSzq25l+FIp6W8I39wJfXS00=";

  mypy-boto3-wafv2 = buildMypyBoto3Package "wafv2" "1.33.0" "sha256-TfoNQglb5u8Ds55tHwYMTI/z1pwvH/c7N4zuat39Fek=";

  mypy-boto3-wellarchitected = buildMypyBoto3Package "wellarchitected" "1.33.0" "sha256-PY40gzjFEUcQziYjRa1/hzMwcM6CkB8WHmf6WiOde3Q=";

  mypy-boto3-wisdom = buildMypyBoto3Package "wisdom" "1.33.0" "sha256-Coer7cmbnagZO4GilB2ymabrAgqbEHFYix6ElDLPI44=";

  mypy-boto3-workdocs = buildMypyBoto3Package "workdocs" "1.33.0" "sha256-I5TUfy5QIk3zDeWZ/vWLk+Nu/I/KmlORnLdMBjwo3EI=";

  mypy-boto3-worklink = buildMypyBoto3Package "worklink" "1.33.0" "sha256-4uf5Yx1oJZvRzz0T7QJDtcLgy7I0GC71GjRfad0ZvQ0=";

  mypy-boto3-workmail = buildMypyBoto3Package "workmail" "1.33.0" "sha256-c3mYtWZZoIG1vLfbvZHvc4N51e+HUJoOtYAunn3ZnoI=";

  mypy-boto3-workmailmessageflow = buildMypyBoto3Package "workmailmessageflow" "1.33.0" "sha256-86zGiMsBeyOcTmwZ84McmHlRCbk3OLIp5DHdtqoUjwo=";

  mypy-boto3-workspaces = buildMypyBoto3Package "workspaces" "1.33.0" "sha256-bryzSjYbSC789o2YWqCvFUqrEOgA0R11Uf9QKe6R1yI=";

  mypy-boto3-workspaces-web = buildMypyBoto3Package "workspaces-web" "1.33.0" "sha256-b1IlikX82GNZmzH9HlAouwf4chh2wMphZkMTF97kWyk=";

  mypy-boto3-xray = buildMypyBoto3Package "xray" "1.33.0" "sha256-x15vxbgn3bCC19N5S9kg4/cQPgZtjJfMzU5oSsxHvzs=";

  }
