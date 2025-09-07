{
  lib,
  boto3,
  botocore,
  botocore-stubs,
  buildPythonPackage,
  fetchPypi,
  mypy-boto3-accessanalyzer,
  mypy-boto3-account,
  mypy-boto3-acm,
  mypy-boto3-acm-pca,
  mypy-boto3-amp,
  mypy-boto3-amplify,
  mypy-boto3-amplifybackend,
  mypy-boto3-amplifyuibuilder,
  mypy-boto3-apigateway,
  mypy-boto3-apigatewaymanagementapi,
  mypy-boto3-apigatewayv2,
  mypy-boto3-appconfig,
  mypy-boto3-appconfigdata,
  mypy-boto3-appfabric,
  mypy-boto3-appflow,
  mypy-boto3-appintegrations,
  mypy-boto3-application-autoscaling,
  mypy-boto3-application-insights,
  mypy-boto3-applicationcostprofiler,
  mypy-boto3-appmesh,
  mypy-boto3-apprunner,
  mypy-boto3-appstream,
  mypy-boto3-appsync,
  mypy-boto3-arc-zonal-shift,
  mypy-boto3-athena,
  mypy-boto3-auditmanager,
  mypy-boto3-autoscaling,
  mypy-boto3-autoscaling-plans,
  mypy-boto3-backup,
  mypy-boto3-backup-gateway,
  mypy-boto3-batch,
  mypy-boto3-billingconductor,
  mypy-boto3-braket,
  mypy-boto3-budgets,
  mypy-boto3-ce,
  mypy-boto3-chime,
  mypy-boto3-chime-sdk-identity,
  mypy-boto3-chime-sdk-media-pipelines,
  mypy-boto3-chime-sdk-meetings,
  mypy-boto3-chime-sdk-messaging,
  mypy-boto3-chime-sdk-voice,
  mypy-boto3-cleanrooms,
  mypy-boto3-cloud9,
  mypy-boto3-cloudcontrol,
  mypy-boto3-clouddirectory,
  mypy-boto3-cloudformation,
  mypy-boto3-cloudfront,
  mypy-boto3-cloudhsm,
  mypy-boto3-cloudhsmv2,
  mypy-boto3-cloudsearch,
  mypy-boto3-cloudsearchdomain,
  mypy-boto3-cloudtrail,
  mypy-boto3-cloudtrail-data,
  mypy-boto3-cloudwatch,
  mypy-boto3-codeartifact,
  mypy-boto3-codebuild,
  mypy-boto3-codecatalyst,
  mypy-boto3-codecommit,
  mypy-boto3-codedeploy,
  mypy-boto3-codeguru-reviewer,
  mypy-boto3-codeguru-security,
  mypy-boto3-codeguruprofiler,
  mypy-boto3-codepipeline,
  mypy-boto3-codestar,
  mypy-boto3-codestar-connections,
  mypy-boto3-codestar-notifications,
  mypy-boto3-cognito-identity,
  mypy-boto3-cognito-idp,
  mypy-boto3-cognito-sync,
  mypy-boto3-comprehend,
  mypy-boto3-comprehendmedical,
  mypy-boto3-compute-optimizer,
  mypy-boto3-config,
  mypy-boto3-connect,
  mypy-boto3-connect-contact-lens,
  mypy-boto3-connectcampaigns,
  mypy-boto3-connectcases,
  mypy-boto3-connectparticipant,
  mypy-boto3-controltower,
  mypy-boto3-cur,
  mypy-boto3-customer-profiles,
  mypy-boto3-databrew,
  mypy-boto3-dataexchange,
  mypy-boto3-datapipeline,
  mypy-boto3-datasync,
  mypy-boto3-dax,
  mypy-boto3-detective,
  mypy-boto3-devicefarm,
  mypy-boto3-devops-guru,
  mypy-boto3-directconnect,
  mypy-boto3-discovery,
  mypy-boto3-dlm,
  mypy-boto3-dms,
  mypy-boto3-docdb,
  mypy-boto3-docdb-elastic,
  mypy-boto3-drs,
  mypy-boto3-ds,
  mypy-boto3-dynamodb,
  mypy-boto3-dynamodbstreams,
  mypy-boto3-ebs,
  mypy-boto3-ec2,
  mypy-boto3-ec2-instance-connect,
  mypy-boto3-ecr,
  mypy-boto3-ecr-public,
  mypy-boto3-ecs,
  mypy-boto3-efs,
  mypy-boto3-eks,
  mypy-boto3-elastic-inference,
  mypy-boto3-elasticache,
  mypy-boto3-elasticbeanstalk,
  mypy-boto3-elastictranscoder,
  mypy-boto3-elb,
  mypy-boto3-elbv2,
  mypy-boto3-emr,
  mypy-boto3-emr-containers,
  mypy-boto3-emr-serverless,
  mypy-boto3-entityresolution,
  mypy-boto3-es,
  mypy-boto3-events,
  mypy-boto3-evidently,
  mypy-boto3-finspace,
  mypy-boto3-finspace-data,
  mypy-boto3-firehose,
  mypy-boto3-fis,
  mypy-boto3-fms,
  mypy-boto3-forecast,
  mypy-boto3-forecastquery,
  mypy-boto3-frauddetector,
  mypy-boto3-fsx,
  mypy-boto3-gamelift,
  mypy-boto3-glacier,
  mypy-boto3-globalaccelerator,
  mypy-boto3-glue,
  mypy-boto3-grafana,
  mypy-boto3-greengrass,
  mypy-boto3-greengrassv2,
  mypy-boto3-groundstation,
  mypy-boto3-guardduty,
  mypy-boto3-health,
  mypy-boto3-healthlake,
  mypy-boto3-iam,
  mypy-boto3-identitystore,
  mypy-boto3-imagebuilder,
  mypy-boto3-importexport,
  mypy-boto3-inspector,
  mypy-boto3-inspector2,
  mypy-boto3-internetmonitor,
  mypy-boto3-iot,
  mypy-boto3-iot-data,
  mypy-boto3-iot-jobs-data,
  mypy-boto3-iot1click-devices,
  mypy-boto3-iot1click-projects,
  mypy-boto3-iotanalytics,
  mypy-boto3-iotdeviceadvisor,
  mypy-boto3-iotevents,
  mypy-boto3-iotevents-data,
  mypy-boto3-iotfleethub,
  mypy-boto3-iotfleetwise,
  mypy-boto3-iotsecuretunneling,
  mypy-boto3-iotsitewise,
  mypy-boto3-iotthingsgraph,
  mypy-boto3-iottwinmaker,
  mypy-boto3-iotwireless,
  mypy-boto3-ivs,
  mypy-boto3-ivs-realtime,
  mypy-boto3-ivschat,
  mypy-boto3-kafka,
  mypy-boto3-kafkaconnect,
  mypy-boto3-kendra,
  mypy-boto3-kendra-ranking,
  mypy-boto3-keyspaces,
  mypy-boto3-kinesis,
  mypy-boto3-kinesis-video-archived-media,
  mypy-boto3-kinesis-video-media,
  mypy-boto3-kinesis-video-signaling,
  mypy-boto3-kinesis-video-webrtc-storage,
  mypy-boto3-kinesisanalytics,
  mypy-boto3-kinesisanalyticsv2,
  mypy-boto3-kinesisvideo,
  mypy-boto3-kms,
  mypy-boto3-lakeformation,
  mypy-boto3-lambda,
  mypy-boto3-lex-models,
  mypy-boto3-lex-runtime,
  mypy-boto3-lexv2-models,
  mypy-boto3-lexv2-runtime,
  mypy-boto3-license-manager,
  mypy-boto3-license-manager-linux-subscriptions,
  mypy-boto3-license-manager-user-subscriptions,
  mypy-boto3-lightsail,
  mypy-boto3-location,
  mypy-boto3-logs,
  mypy-boto3-lookoutequipment,
  mypy-boto3-lookoutmetrics,
  mypy-boto3-lookoutvision,
  mypy-boto3-m2,
  mypy-boto3-machinelearning,
  mypy-boto3-macie2,
  mypy-boto3-managedblockchain,
  mypy-boto3-managedblockchain-query,
  mypy-boto3-marketplace-catalog,
  mypy-boto3-marketplace-entitlement,
  mypy-boto3-marketplacecommerceanalytics,
  mypy-boto3-mediaconnect,
  mypy-boto3-mediaconvert,
  mypy-boto3-medialive,
  mypy-boto3-mediapackage,
  mypy-boto3-mediapackage-vod,
  mypy-boto3-mediapackagev2,
  mypy-boto3-mediastore,
  mypy-boto3-mediastore-data,
  mypy-boto3-mediatailor,
  mypy-boto3-medical-imaging,
  mypy-boto3-memorydb,
  mypy-boto3-meteringmarketplace,
  mypy-boto3-mgh,
  mypy-boto3-mgn,
  mypy-boto3-migration-hub-refactor-spaces,
  mypy-boto3-migrationhub-config,
  mypy-boto3-migrationhuborchestrator,
  mypy-boto3-migrationhubstrategy,
  mypy-boto3-mq,
  mypy-boto3-mturk,
  mypy-boto3-mwaa,
  mypy-boto3-neptune,
  mypy-boto3-network-firewall,
  mypy-boto3-networkmanager,
  mypy-boto3-nimble,
  mypy-boto3-oam,
  mypy-boto3-omics,
  mypy-boto3-opensearch,
  mypy-boto3-opensearchserverless,
  mypy-boto3-opsworks,
  mypy-boto3-opsworkscm,
  mypy-boto3-organizations,
  mypy-boto3-osis,
  mypy-boto3-outposts,
  mypy-boto3-panorama,
  mypy-boto3-payment-cryptography,
  mypy-boto3-payment-cryptography-data,
  mypy-boto3-personalize,
  mypy-boto3-personalize-events,
  mypy-boto3-personalize-runtime,
  mypy-boto3-pi,
  mypy-boto3-pinpoint,
  mypy-boto3-pinpoint-email,
  mypy-boto3-pinpoint-sms-voice,
  mypy-boto3-pinpoint-sms-voice-v2,
  mypy-boto3-pipes,
  mypy-boto3-polly,
  mypy-boto3-pricing,
  mypy-boto3-privatenetworks,
  mypy-boto3-proton,
  mypy-boto3-qldb,
  mypy-boto3-qldb-session,
  mypy-boto3-quicksight,
  mypy-boto3-ram,
  mypy-boto3-rbin,
  mypy-boto3-rds,
  mypy-boto3-rds-data,
  mypy-boto3-redshift,
  mypy-boto3-redshift-data,
  mypy-boto3-redshift-serverless,
  mypy-boto3-rekognition,
  mypy-boto3-resiliencehub,
  mypy-boto3-resource-explorer-2,
  mypy-boto3-resource-groups,
  mypy-boto3-resourcegroupstaggingapi,
  mypy-boto3-robomaker,
  mypy-boto3-rolesanywhere,
  mypy-boto3-route53,
  mypy-boto3-route53-recovery-cluster,
  mypy-boto3-route53-recovery-control-config,
  mypy-boto3-route53-recovery-readiness,
  mypy-boto3-route53domains,
  mypy-boto3-route53resolver,
  mypy-boto3-rum,
  mypy-boto3-s3,
  mypy-boto3-s3control,
  mypy-boto3-s3outposts,
  mypy-boto3-sagemaker,
  mypy-boto3-sagemaker-a2i-runtime,
  mypy-boto3-sagemaker-edge,
  mypy-boto3-sagemaker-featurestore-runtime,
  mypy-boto3-sagemaker-geospatial,
  mypy-boto3-sagemaker-metrics,
  mypy-boto3-sagemaker-runtime,
  mypy-boto3-savingsplans,
  mypy-boto3-scheduler,
  mypy-boto3-schemas,
  mypy-boto3-sdb,
  mypy-boto3-secretsmanager,
  mypy-boto3-securityhub,
  mypy-boto3-securitylake,
  mypy-boto3-serverlessrepo,
  mypy-boto3-service-quotas,
  mypy-boto3-servicecatalog,
  mypy-boto3-servicecatalog-appregistry,
  mypy-boto3-servicediscovery,
  mypy-boto3-ses,
  mypy-boto3-sesv2,
  mypy-boto3-shield,
  mypy-boto3-signer,
  mypy-boto3-simspaceweaver,
  mypy-boto3-sms,
  mypy-boto3-sms-voice,
  mypy-boto3-snow-device-management,
  mypy-boto3-snowball,
  mypy-boto3-sns,
  mypy-boto3-sqs,
  mypy-boto3-ssm,
  mypy-boto3-ssm-contacts,
  mypy-boto3-ssm-incidents,
  mypy-boto3-ssm-sap,
  mypy-boto3-sso,
  mypy-boto3-sso-admin,
  mypy-boto3-sso-oidc,
  mypy-boto3-stepfunctions,
  mypy-boto3-storagegateway,
  mypy-boto3-sts,
  mypy-boto3-support,
  mypy-boto3-support-app,
  mypy-boto3-swf,
  mypy-boto3-synthetics,
  mypy-boto3-textract,
  mypy-boto3-timestream-query,
  mypy-boto3-timestream-write,
  mypy-boto3-tnb,
  mypy-boto3-transcribe,
  mypy-boto3-transfer,
  mypy-boto3-translate,
  mypy-boto3-verifiedpermissions,
  mypy-boto3-voice-id,
  mypy-boto3-vpc-lattice,
  mypy-boto3-waf,
  mypy-boto3-waf-regional,
  mypy-boto3-wafv2,
  mypy-boto3-wellarchitected,
  mypy-boto3-wisdom,
  mypy-boto3-workdocs,
  mypy-boto3-worklink,
  mypy-boto3-workmail,
  mypy-boto3-workmailmessageflow,
  mypy-boto3-workspaces,
  mypy-boto3-workspaces-web,
  mypy-boto3-xray,
  pythonOlder,
  setuptools,
  types-s3transfer,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "boto3-stubs";
  version = "1.40.24";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "boto3_stubs";
    inherit version;
    hash = "sha256-U9ezPaAAE0lVd8l58wknH7UWbXPW1C7F9qPJinaMUIo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    botocore-stubs
    types-s3transfer
    typing-extensions
  ];

  optional-dependencies = {
    accessanalyzer = [ mypy-boto3-accessanalyzer ];
    account = [ mypy-boto3-account ];
    acm = [ mypy-boto3-acm ];
    acm-pca = [ mypy-boto3-acm-pca ];
    all = [
      mypy-boto3-accessanalyzer
      mypy-boto3-account
      mypy-boto3-acm
      mypy-boto3-acm-pca
      mypy-boto3-amp
      mypy-boto3-amplify
      mypy-boto3-amplifybackend
      mypy-boto3-amplifyuibuilder
      mypy-boto3-apigateway
      mypy-boto3-apigatewaymanagementapi
      mypy-boto3-apigatewayv2
      mypy-boto3-appconfig
      mypy-boto3-appconfigdata
      mypy-boto3-appfabric
      mypy-boto3-appflow
      mypy-boto3-appintegrations
      mypy-boto3-application-autoscaling
      mypy-boto3-application-insights
      mypy-boto3-applicationcostprofiler
      mypy-boto3-appmesh
      mypy-boto3-apprunner
      mypy-boto3-appstream
      mypy-boto3-appsync
      mypy-boto3-arc-zonal-shift
      mypy-boto3-athena
      mypy-boto3-auditmanager
      mypy-boto3-autoscaling
      mypy-boto3-autoscaling-plans
      mypy-boto3-backup
      mypy-boto3-backup-gateway
      mypy-boto3-batch
      mypy-boto3-billingconductor
      mypy-boto3-braket
      mypy-boto3-budgets
      mypy-boto3-ce
      mypy-boto3-chime
      mypy-boto3-chime-sdk-identity
      mypy-boto3-chime-sdk-media-pipelines
      mypy-boto3-chime-sdk-meetings
      mypy-boto3-chime-sdk-messaging
      mypy-boto3-chime-sdk-voice
      mypy-boto3-cleanrooms
      mypy-boto3-cloud9
      mypy-boto3-cloudcontrol
      mypy-boto3-clouddirectory
      mypy-boto3-cloudformation
      mypy-boto3-cloudfront
      mypy-boto3-cloudhsm
      mypy-boto3-cloudhsmv2
      mypy-boto3-cloudsearch
      mypy-boto3-cloudsearchdomain
      mypy-boto3-cloudtrail
      mypy-boto3-cloudtrail-data
      mypy-boto3-cloudwatch
      mypy-boto3-codeartifact
      mypy-boto3-codebuild
      mypy-boto3-codecatalyst
      mypy-boto3-codecommit
      mypy-boto3-codedeploy
      mypy-boto3-codeguru-reviewer
      mypy-boto3-codeguru-security
      mypy-boto3-codeguruprofiler
      mypy-boto3-codepipeline
      mypy-boto3-codestar
      mypy-boto3-codestar-connections
      mypy-boto3-codestar-notifications
      mypy-boto3-cognito-identity
      mypy-boto3-cognito-idp
      mypy-boto3-cognito-sync
      mypy-boto3-comprehend
      mypy-boto3-comprehendmedical
      mypy-boto3-compute-optimizer
      mypy-boto3-config
      mypy-boto3-connect
      mypy-boto3-connect-contact-lens
      mypy-boto3-connectcampaigns
      mypy-boto3-connectcases
      mypy-boto3-connectparticipant
      mypy-boto3-controltower
      mypy-boto3-cur
      mypy-boto3-customer-profiles
      mypy-boto3-databrew
      mypy-boto3-dataexchange
      mypy-boto3-datapipeline
      mypy-boto3-datasync
      mypy-boto3-dax
      mypy-boto3-detective
      mypy-boto3-devicefarm
      mypy-boto3-devops-guru
      mypy-boto3-directconnect
      mypy-boto3-discovery
      mypy-boto3-dlm
      mypy-boto3-dms
      mypy-boto3-docdb
      mypy-boto3-docdb-elastic
      mypy-boto3-drs
      mypy-boto3-ds
      mypy-boto3-dynamodb
      mypy-boto3-dynamodbstreams
      mypy-boto3-ebs
      mypy-boto3-ec2
      mypy-boto3-ec2-instance-connect
      mypy-boto3-ecr
      mypy-boto3-ecr-public
      mypy-boto3-ecs
      mypy-boto3-efs
      mypy-boto3-eks
      mypy-boto3-elastic-inference
      mypy-boto3-elasticache
      mypy-boto3-elasticbeanstalk
      mypy-boto3-elastictranscoder
      mypy-boto3-elb
      mypy-boto3-elbv2
      mypy-boto3-emr
      mypy-boto3-emr-containers
      mypy-boto3-emr-serverless
      mypy-boto3-entityresolution
      mypy-boto3-es
      mypy-boto3-events
      mypy-boto3-evidently
      mypy-boto3-finspace
      mypy-boto3-finspace-data
      mypy-boto3-firehose
      mypy-boto3-fis
      mypy-boto3-fms
      mypy-boto3-forecast
      mypy-boto3-forecastquery
      mypy-boto3-frauddetector
      mypy-boto3-fsx
      mypy-boto3-gamelift
      mypy-boto3-glacier
      mypy-boto3-globalaccelerator
      mypy-boto3-glue
      mypy-boto3-grafana
      mypy-boto3-greengrass
      mypy-boto3-greengrassv2
      mypy-boto3-groundstation
      mypy-boto3-guardduty
      mypy-boto3-health
      mypy-boto3-healthlake
      mypy-boto3-iam
      mypy-boto3-identitystore
      mypy-boto3-imagebuilder
      mypy-boto3-importexport
      mypy-boto3-inspector
      mypy-boto3-inspector2
      mypy-boto3-internetmonitor
      mypy-boto3-iot
      mypy-boto3-iot-data
      mypy-boto3-iot-jobs-data
      mypy-boto3-iot1click-devices
      mypy-boto3-iot1click-projects
      mypy-boto3-iotanalytics
      mypy-boto3-iotdeviceadvisor
      mypy-boto3-iotevents
      mypy-boto3-iotevents-data
      mypy-boto3-iotfleethub
      mypy-boto3-iotfleetwise
      mypy-boto3-iotsecuretunneling
      mypy-boto3-iotsitewise
      mypy-boto3-iotthingsgraph
      mypy-boto3-iottwinmaker
      mypy-boto3-iotwireless
      mypy-boto3-ivs
      mypy-boto3-ivs-realtime
      mypy-boto3-ivschat
      mypy-boto3-kafka
      mypy-boto3-kafkaconnect
      mypy-boto3-kendra
      mypy-boto3-kendra-ranking
      mypy-boto3-keyspaces
      mypy-boto3-kinesis
      mypy-boto3-kinesis-video-archived-media
      mypy-boto3-kinesis-video-media
      mypy-boto3-kinesis-video-signaling
      mypy-boto3-kinesis-video-webrtc-storage
      mypy-boto3-kinesisanalytics
      mypy-boto3-kinesisanalyticsv2
      mypy-boto3-kinesisvideo
      mypy-boto3-kms
      mypy-boto3-lakeformation
      mypy-boto3-lambda
      mypy-boto3-lex-models
      mypy-boto3-lex-runtime
      mypy-boto3-lexv2-models
      mypy-boto3-lexv2-runtime
      mypy-boto3-license-manager
      mypy-boto3-license-manager-linux-subscriptions
      mypy-boto3-license-manager-user-subscriptions
      mypy-boto3-lightsail
      mypy-boto3-location
      mypy-boto3-logs
      mypy-boto3-lookoutequipment
      mypy-boto3-lookoutmetrics
      mypy-boto3-lookoutvision
      mypy-boto3-m2
      mypy-boto3-machinelearning
      mypy-boto3-macie2
      mypy-boto3-managedblockchain
      mypy-boto3-managedblockchain-query
      mypy-boto3-marketplace-catalog
      mypy-boto3-marketplace-entitlement
      mypy-boto3-marketplacecommerceanalytics
      mypy-boto3-mediaconnect
      mypy-boto3-mediaconvert
      mypy-boto3-medialive
      mypy-boto3-mediapackage
      mypy-boto3-mediapackage-vod
      mypy-boto3-mediapackagev2
      mypy-boto3-mediastore
      mypy-boto3-mediastore-data
      mypy-boto3-mediatailor
      mypy-boto3-medical-imaging
      mypy-boto3-memorydb
      mypy-boto3-meteringmarketplace
      mypy-boto3-mgh
      mypy-boto3-mgn
      mypy-boto3-migration-hub-refactor-spaces
      mypy-boto3-migrationhub-config
      mypy-boto3-migrationhuborchestrator
      mypy-boto3-migrationhubstrategy
      mypy-boto3-mq
      mypy-boto3-mturk
      mypy-boto3-mwaa
      mypy-boto3-neptune
      mypy-boto3-network-firewall
      mypy-boto3-networkmanager
      mypy-boto3-nimble
      mypy-boto3-oam
      mypy-boto3-omics
      mypy-boto3-opensearch
      mypy-boto3-opensearchserverless
      mypy-boto3-opsworks
      mypy-boto3-opsworkscm
      mypy-boto3-organizations
      mypy-boto3-osis
      mypy-boto3-outposts
      mypy-boto3-panorama
      mypy-boto3-payment-cryptography
      mypy-boto3-payment-cryptography-data
      mypy-boto3-personalize
      mypy-boto3-personalize-events
      mypy-boto3-personalize-runtime
      mypy-boto3-pi
      mypy-boto3-pinpoint
      mypy-boto3-pinpoint-email
      mypy-boto3-pinpoint-sms-voice
      mypy-boto3-pinpoint-sms-voice-v2
      mypy-boto3-pipes
      mypy-boto3-polly
      mypy-boto3-pricing
      mypy-boto3-privatenetworks
      mypy-boto3-proton
      mypy-boto3-qldb
      mypy-boto3-qldb-session
      mypy-boto3-quicksight
      mypy-boto3-ram
      mypy-boto3-rbin
      mypy-boto3-rds
      mypy-boto3-rds-data
      mypy-boto3-redshift
      mypy-boto3-redshift-data
      mypy-boto3-redshift-serverless
      mypy-boto3-rekognition
      mypy-boto3-resiliencehub
      mypy-boto3-resource-explorer-2
      mypy-boto3-resource-groups
      mypy-boto3-resourcegroupstaggingapi
      mypy-boto3-robomaker
      mypy-boto3-rolesanywhere
      mypy-boto3-route53
      mypy-boto3-route53-recovery-cluster
      mypy-boto3-route53-recovery-control-config
      mypy-boto3-route53-recovery-readiness
      mypy-boto3-route53domains
      mypy-boto3-route53resolver
      mypy-boto3-rum
      mypy-boto3-s3
      mypy-boto3-s3control
      mypy-boto3-s3outposts
      mypy-boto3-sagemaker
      mypy-boto3-sagemaker-a2i-runtime
      mypy-boto3-sagemaker-edge
      mypy-boto3-sagemaker-featurestore-runtime
      mypy-boto3-sagemaker-geospatial
      mypy-boto3-sagemaker-metrics
      mypy-boto3-sagemaker-runtime
      mypy-boto3-savingsplans
      mypy-boto3-scheduler
      mypy-boto3-schemas
      mypy-boto3-sdb
      mypy-boto3-secretsmanager
      mypy-boto3-securityhub
      mypy-boto3-securitylake
      mypy-boto3-serverlessrepo
      mypy-boto3-service-quotas
      mypy-boto3-servicecatalog
      mypy-boto3-servicecatalog-appregistry
      mypy-boto3-servicediscovery
      mypy-boto3-ses
      mypy-boto3-sesv2
      mypy-boto3-shield
      mypy-boto3-signer
      mypy-boto3-simspaceweaver
      mypy-boto3-sms
      mypy-boto3-sms-voice
      mypy-boto3-snow-device-management
      mypy-boto3-snowball
      mypy-boto3-sns
      mypy-boto3-sqs
      mypy-boto3-ssm
      mypy-boto3-ssm-contacts
      mypy-boto3-ssm-incidents
      mypy-boto3-ssm-sap
      mypy-boto3-sso
      mypy-boto3-sso-admin
      mypy-boto3-sso-oidc
      mypy-boto3-stepfunctions
      mypy-boto3-storagegateway
      mypy-boto3-sts
      mypy-boto3-support
      mypy-boto3-support-app
      mypy-boto3-swf
      mypy-boto3-synthetics
      mypy-boto3-textract
      mypy-boto3-timestream-query
      mypy-boto3-timestream-write
      mypy-boto3-tnb
      mypy-boto3-transcribe
      mypy-boto3-transfer
      mypy-boto3-translate
      mypy-boto3-verifiedpermissions
      mypy-boto3-voice-id
      mypy-boto3-vpc-lattice
      mypy-boto3-waf
      mypy-boto3-waf-regional
      mypy-boto3-wafv2
      mypy-boto3-wellarchitected
      mypy-boto3-wisdom
      mypy-boto3-workdocs
      mypy-boto3-worklink
      mypy-boto3-workmail
      mypy-boto3-workmailmessageflow
      mypy-boto3-workspaces
      mypy-boto3-workspaces-web
      mypy-boto3-xray
    ];
    amp = [ mypy-boto3-amp ];
    amplify = [ mypy-boto3-amplify ];
    amplifybackend = [ mypy-boto3-amplifybackend ];
    amplifyuibuilder = [ mypy-boto3-amplifyuibuilder ];
    apigateway = [ mypy-boto3-apigateway ];
    apigatewaymanagementapi = [ mypy-boto3-apigatewaymanagementapi ];
    apigatewayv2 = [ mypy-boto3-apigatewayv2 ];
    appconfig = [ mypy-boto3-appconfig ];
    appconfigdata = [ mypy-boto3-appconfigdata ];
    appfabric = [ mypy-boto3-appfabric ];
    appflow = [ mypy-boto3-appflow ];
    appintegrations = [ mypy-boto3-appintegrations ];
    application-autoscaling = [ mypy-boto3-application-autoscaling ];
    application-insights = [ mypy-boto3-application-insights ];
    applicationcostprofiler = [ mypy-boto3-applicationcostprofiler ];
    appmesh = [ mypy-boto3-appmesh ];
    apprunner = [ mypy-boto3-apprunner ];
    appstream = [ mypy-boto3-appstream ];
    appsync = [ mypy-boto3-appsync ];
    arc-zonal-shift = [ mypy-boto3-arc-zonal-shift ];
    athena = [ mypy-boto3-athena ];
    auditmanager = [ mypy-boto3-auditmanager ];
    autoscaling = [ mypy-boto3-autoscaling ];
    autoscaling-plans = [ mypy-boto3-autoscaling-plans ];
    backup = [ mypy-boto3-backup ];
    backup-gateway = [ mypy-boto3-backup-gateway ];
    batch = [ mypy-boto3-batch ];
    billingconductor = [ mypy-boto3-billingconductor ];
    boto3 = [
      boto3
      botocore
    ];
    braket = [ mypy-boto3-braket ];
    budgets = [ mypy-boto3-budgets ];
    ce = [ mypy-boto3-ce ];
    chime = [ mypy-boto3-chime ];
    chime-sdk-identity = [ mypy-boto3-chime-sdk-identity ];
    chime-sdk-media-pipelines = [ mypy-boto3-chime-sdk-media-pipelines ];
    chime-sdk-meetings = [ mypy-boto3-chime-sdk-meetings ];
    chime-sdk-messaging = [ mypy-boto3-chime-sdk-messaging ];
    chime-sdk-voice = [ mypy-boto3-chime-sdk-voice ];
    cleanrooms = [ mypy-boto3-cleanrooms ];
    cloud9 = [ mypy-boto3-cloud9 ];
    cloudcontrol = [ mypy-boto3-cloudcontrol ];
    clouddirectory = [ mypy-boto3-clouddirectory ];
    cloudformation = [ mypy-boto3-cloudformation ];
    cloudfront = [ mypy-boto3-cloudfront ];
    cloudhsm = [ mypy-boto3-cloudhsm ];
    cloudhsmv2 = [ mypy-boto3-cloudhsmv2 ];
    cloudsearch = [ mypy-boto3-cloudsearch ];
    cloudsearchdomain = [ mypy-boto3-cloudsearchdomain ];
    cloudtrail = [ mypy-boto3-cloudtrail ];
    cloudtrail-data = [ mypy-boto3-cloudtrail-data ];
    cloudwatch = [ mypy-boto3-cloudwatch ];
    codeartifact = [ mypy-boto3-codeartifact ];
    codebuild = [ mypy-boto3-codebuild ];
    codecatalyst = [ mypy-boto3-codecatalyst ];
    codecommit = [ mypy-boto3-codecommit ];
    codedeploy = [ mypy-boto3-codedeploy ];
    codeguru-reviewer = [ mypy-boto3-codeguru-reviewer ];
    codeguru-security = [ mypy-boto3-codeguru-security ];
    codeguruprofiler = [ mypy-boto3-codeguruprofiler ];
    codepipeline = [ mypy-boto3-codepipeline ];
    codestar = [ mypy-boto3-codestar ];
    codestar-connections = [ mypy-boto3-codestar-connections ];
    codestar-notifications = [ mypy-boto3-codestar-notifications ];
    cognito-identity = [ mypy-boto3-cognito-identity ];
    cognito-idp = [ mypy-boto3-cognito-idp ];
    cognito-sync = [ mypy-boto3-cognito-sync ];
    comprehend = [ mypy-boto3-comprehend ];
    comprehendmedical = [ mypy-boto3-comprehendmedical ];
    compute-optimizer = [ mypy-boto3-compute-optimizer ];
    config = [ mypy-boto3-config ];
    connect = [ mypy-boto3-connect ];
    connect-contact-lens = [ mypy-boto3-connect-contact-lens ];
    connectcampaigns = [ mypy-boto3-connectcampaigns ];
    connectcases = [ mypy-boto3-connectcases ];
    connectparticipant = [ mypy-boto3-connectparticipant ];
    controltower = [ mypy-boto3-controltower ];
    cur = [ mypy-boto3-cur ];
    customer-profiles = [ mypy-boto3-customer-profiles ];
    databrew = [ mypy-boto3-databrew ];
    dataexchange = [ mypy-boto3-dataexchange ];
    datapipeline = [ mypy-boto3-datapipeline ];
    datasync = [ mypy-boto3-datasync ];
    dax = [ mypy-boto3-dax ];
    detective = [ mypy-boto3-detective ];
    devicefarm = [ mypy-boto3-devicefarm ];
    devops-guru = [ mypy-boto3-devops-guru ];
    directconnect = [ mypy-boto3-directconnect ];
    discovery = [ mypy-boto3-discovery ];
    dlm = [ mypy-boto3-dlm ];
    dms = [ mypy-boto3-dms ];
    docdb = [ mypy-boto3-docdb ];
    docdb-elastic = [ mypy-boto3-docdb-elastic ];
    drs = [ mypy-boto3-drs ];
    ds = [ mypy-boto3-ds ];
    dynamodb = [ mypy-boto3-dynamodb ];
    dynamodbstreams = [ mypy-boto3-dynamodbstreams ];
    ebs = [ mypy-boto3-ebs ];
    ec2 = [ mypy-boto3-ec2 ];
    ec2-instance-connect = [ mypy-boto3-ec2-instance-connect ];
    ecr = [ mypy-boto3-ecr ];
    ecr-public = [ mypy-boto3-ecr-public ];
    ecs = [ mypy-boto3-ecs ];
    efs = [ mypy-boto3-efs ];
    eks = [ mypy-boto3-eks ];
    elastic-inference = [ mypy-boto3-elastic-inference ];
    elasticache = [ mypy-boto3-elasticache ];
    elasticbeanstalk = [ mypy-boto3-elasticbeanstalk ];
    elastictranscoder = [ mypy-boto3-elastictranscoder ];
    elb = [ mypy-boto3-elb ];
    elbv2 = [ mypy-boto3-elbv2 ];
    emr = [ mypy-boto3-emr ];
    emr-containers = [ mypy-boto3-emr-containers ];
    emr-serverless = [ mypy-boto3-emr-serverless ];
    entityresolution = [ mypy-boto3-entityresolution ];
    es = [ mypy-boto3-es ];
    essential = [
      mypy-boto3-cloudformation
      mypy-boto3-dynamodb
      mypy-boto3-ec2
      mypy-boto3-lambda
      mypy-boto3-rds
      mypy-boto3-s3
      mypy-boto3-sqs
    ];
    events = [ mypy-boto3-events ];
    evidently = [ mypy-boto3-evidently ];
    finspace = [ mypy-boto3-finspace ];
    finspace-data = [ mypy-boto3-finspace-data ];
    firehose = [ mypy-boto3-firehose ];
    fis = [ mypy-boto3-fis ];
    fms = [ mypy-boto3-fms ];
    forecast = [ mypy-boto3-forecast ];
    forecastquery = [ mypy-boto3-forecastquery ];
    frauddetector = [ mypy-boto3-frauddetector ];
    fsx = [ mypy-boto3-fsx ];
    gamelift = [ mypy-boto3-gamelift ];
    glacier = [ mypy-boto3-glacier ];
    globalaccelerator = [ mypy-boto3-globalaccelerator ];
    glue = [ mypy-boto3-glue ];
    grafana = [ mypy-boto3-grafana ];
    greengrass = [ mypy-boto3-greengrass ];
    greengrassv2 = [ mypy-boto3-greengrassv2 ];
    groundstation = [ mypy-boto3-groundstation ];
    guardduty = [ mypy-boto3-guardduty ];
    health = [ mypy-boto3-health ];
    healthlake = [ mypy-boto3-healthlake ];
    iam = [ mypy-boto3-iam ];
    identitystore = [ mypy-boto3-identitystore ];
    imagebuilder = [ mypy-boto3-imagebuilder ];
    importexport = [ mypy-boto3-importexport ];
    inspector = [ mypy-boto3-inspector ];
    inspector2 = [ mypy-boto3-inspector2 ];
    internetmonitor = [ mypy-boto3-internetmonitor ];
    iot = [ mypy-boto3-iot ];
    iot-data = [ mypy-boto3-iot-data ];
    iot-jobs-data = [ mypy-boto3-iot-jobs-data ];
    iot1click-devices = [ mypy-boto3-iot1click-devices ];
    iot1click-projects = [ mypy-boto3-iot1click-projects ];
    iotanalytics = [ mypy-boto3-iotanalytics ];
    iotdeviceadvisor = [ mypy-boto3-iotdeviceadvisor ];
    iotevents = [ mypy-boto3-iotevents ];
    iotevents-data = [ mypy-boto3-iotevents-data ];
    iotfleethub = [ mypy-boto3-iotfleethub ];
    iotfleetwise = [ mypy-boto3-iotfleetwise ];
    iotsecuretunneling = [ mypy-boto3-iotsecuretunneling ];
    iotsitewise = [ mypy-boto3-iotsitewise ];
    iotthingsgraph = [ mypy-boto3-iotthingsgraph ];
    iottwinmaker = [ mypy-boto3-iottwinmaker ];
    iotwireless = [ mypy-boto3-iotwireless ];
    ivs = [ mypy-boto3-ivs ];
    ivs-realtime = [ mypy-boto3-ivs-realtime ];
    ivschat = [ mypy-boto3-ivschat ];
    kafka = [ mypy-boto3-kafka ];
    kafkaconnect = [ mypy-boto3-kafkaconnect ];
    kendra = [ mypy-boto3-kendra ];
    kendra-ranking = [ mypy-boto3-kendra-ranking ];
    keyspaces = [ mypy-boto3-keyspaces ];
    kinesis = [ mypy-boto3-kinesis ];
    kinesis-video-archived-media = [ mypy-boto3-kinesis-video-archived-media ];
    kinesis-video-media = [ mypy-boto3-kinesis-video-media ];
    kinesis-video-signaling = [ mypy-boto3-kinesis-video-signaling ];
    kinesis-video-webrtc-storage = [ mypy-boto3-kinesis-video-webrtc-storage ];
    kinesisanalytics = [ mypy-boto3-kinesisanalytics ];
    kinesisanalyticsv2 = [ mypy-boto3-kinesisanalyticsv2 ];
    kinesisvideo = [ mypy-boto3-kinesisvideo ];
    kms = [ mypy-boto3-kms ];
    lakeformation = [ mypy-boto3-lakeformation ];
    lambda = [ mypy-boto3-lambda ];
    lex-models = [ mypy-boto3-lex-models ];
    lex-runtime = [ mypy-boto3-lex-runtime ];
    lexv2-models = [ mypy-boto3-lexv2-models ];
    lexv2-runtime = [ mypy-boto3-lexv2-runtime ];
    license-manager = [ mypy-boto3-license-manager ];
    license-manager-linux-subscriptions = [ mypy-boto3-license-manager-linux-subscriptions ];
    license-manager-user-subscriptions = [ mypy-boto3-license-manager-user-subscriptions ];
    lightsail = [ mypy-boto3-lightsail ];
    location = [ mypy-boto3-location ];
    logs = [ mypy-boto3-logs ];
    lookoutequipment = [ mypy-boto3-lookoutequipment ];
    lookoutmetrics = [ mypy-boto3-lookoutmetrics ];
    lookoutvision = [ mypy-boto3-lookoutvision ];
    m2 = [ mypy-boto3-m2 ];
    machinelearning = [ mypy-boto3-machinelearning ];
    macie2 = [ mypy-boto3-macie2 ];
    managedblockchain = [ mypy-boto3-managedblockchain ];
    managedblockchain-query = [ mypy-boto3-managedblockchain-query ];
    marketplace-catalog = [ mypy-boto3-marketplace-catalog ];
    marketplace-entitlement = [ mypy-boto3-marketplace-entitlement ];
    marketplacecommerceanalytics = [ mypy-boto3-marketplacecommerceanalytics ];
    mediaconnect = [ mypy-boto3-mediaconnect ];
    mediaconvert = [ mypy-boto3-mediaconvert ];
    medialive = [ mypy-boto3-medialive ];
    mediapackage = [ mypy-boto3-mediapackage ];
    mediapackage-vod = [ mypy-boto3-mediapackage-vod ];
    mediapackagev2 = [ mypy-boto3-mediapackagev2 ];
    mediastore = [ mypy-boto3-mediastore ];
    mediastore-data = [ mypy-boto3-mediastore-data ];
    mediatailor = [ mypy-boto3-mediatailor ];
    medical-imaging = [ mypy-boto3-medical-imaging ];
    memorydb = [ mypy-boto3-memorydb ];
    meteringmarketplace = [ mypy-boto3-meteringmarketplace ];
    mgh = [ mypy-boto3-mgh ];
    mgn = [ mypy-boto3-mgn ];
    migration-hub-refactor-spaces = [ mypy-boto3-migration-hub-refactor-spaces ];
    migrationhub-config = [ mypy-boto3-migrationhub-config ];
    migrationhuborchestrator = [ mypy-boto3-migrationhuborchestrator ];
    migrationhubstrategy = [ mypy-boto3-migrationhubstrategy ];
    mq = [ mypy-boto3-mq ];
    mturk = [ mypy-boto3-mturk ];
    mwaa = [ mypy-boto3-mwaa ];
    neptune = [ mypy-boto3-neptune ];
    network-firewall = [ mypy-boto3-network-firewall ];
    networkmanager = [ mypy-boto3-networkmanager ];
    nimble = [ mypy-boto3-nimble ];
    oam = [ mypy-boto3-oam ];
    omics = [ mypy-boto3-omics ];
    opensearch = [ mypy-boto3-opensearch ];
    opensearchserverless = [ mypy-boto3-opensearchserverless ];
    opsworks = [ mypy-boto3-opsworks ];
    opsworkscm = [ mypy-boto3-opsworkscm ];
    organizations = [ mypy-boto3-organizations ];
    osis = [ mypy-boto3-osis ];
    outposts = [ mypy-boto3-outposts ];
    panorama = [ mypy-boto3-panorama ];
    payment-cryptography = [ mypy-boto3-payment-cryptography ];
    payment-cryptography-data = [ mypy-boto3-payment-cryptography-data ];
    personalize = [ mypy-boto3-personalize ];
    personalize-events = [ mypy-boto3-personalize-events ];
    personalize-runtime = [ mypy-boto3-personalize-runtime ];
    pi = [ mypy-boto3-pi ];
    pinpoint = [ mypy-boto3-pinpoint ];
    pinpoint-email = [ mypy-boto3-pinpoint-email ];
    pinpoint-sms-voice = [ mypy-boto3-pinpoint-sms-voice ];
    pinpoint-sms-voice-v2 = [ mypy-boto3-pinpoint-sms-voice-v2 ];
    pipes = [ mypy-boto3-pipes ];
    polly = [ mypy-boto3-polly ];
    pricing = [ mypy-boto3-pricing ];
    privatenetworks = [ mypy-boto3-privatenetworks ];
    proton = [ mypy-boto3-proton ];
    qldb = [ mypy-boto3-qldb ];
    qldb-session = [ mypy-boto3-qldb-session ];
    quicksight = [ mypy-boto3-quicksight ];
    ram = [ mypy-boto3-ram ];
    rbin = [ mypy-boto3-rbin ];
    rds = [ mypy-boto3-rds ];
    rds-data = [ mypy-boto3-rds-data ];
    redshift = [ mypy-boto3-redshift ];
    redshift-data = [ mypy-boto3-redshift-data ];
    redshift-serverless = [ mypy-boto3-redshift-serverless ];
    rekognition = [ mypy-boto3-rekognition ];
    resiliencehub = [ mypy-boto3-resiliencehub ];
    resource-explorer-2 = [ mypy-boto3-resource-explorer-2 ];
    resource-groups = [ mypy-boto3-resource-groups ];
    resourcegroupstaggingapi = [ mypy-boto3-resourcegroupstaggingapi ];
    robomaker = [ mypy-boto3-robomaker ];
    rolesanywhere = [ mypy-boto3-rolesanywhere ];
    route53 = [ mypy-boto3-route53 ];
    route53-recovery-cluster = [ mypy-boto3-route53-recovery-cluster ];
    route53-recovery-control-config = [ mypy-boto3-route53-recovery-control-config ];
    route53-recovery-readiness = [ mypy-boto3-route53-recovery-readiness ];
    route53domains = [ mypy-boto3-route53domains ];
    route53resolver = [ mypy-boto3-route53resolver ];
    rum = [ mypy-boto3-rum ];
    s3 = [ mypy-boto3-s3 ];
    s3control = [ mypy-boto3-s3control ];
    s3outposts = [ mypy-boto3-s3outposts ];
    sagemaker = [ mypy-boto3-sagemaker ];
    sagemaker-a2i-runtime = [ mypy-boto3-sagemaker-a2i-runtime ];
    sagemaker-edge = [ mypy-boto3-sagemaker-edge ];
    sagemaker-featurestore-runtime = [ mypy-boto3-sagemaker-featurestore-runtime ];
    sagemaker-geospatial = [ mypy-boto3-sagemaker-geospatial ];
    sagemaker-metrics = [ mypy-boto3-sagemaker-metrics ];
    sagemaker-runtime = [ mypy-boto3-sagemaker-runtime ];
    savingsplans = [ mypy-boto3-savingsplans ];
    scheduler = [ mypy-boto3-scheduler ];
    schemas = [ mypy-boto3-schemas ];
    sdb = [ mypy-boto3-sdb ];
    secretsmanager = [ mypy-boto3-secretsmanager ];
    securityhub = [ mypy-boto3-securityhub ];
    securitylake = [ mypy-boto3-securitylake ];
    serverlessrepo = [ mypy-boto3-serverlessrepo ];
    service-quotas = [ mypy-boto3-service-quotas ];
    servicecatalog = [ mypy-boto3-servicecatalog ];
    servicecatalog-appregistry = [ mypy-boto3-servicecatalog-appregistry ];
    servicediscovery = [ mypy-boto3-servicediscovery ];
    ses = [ mypy-boto3-ses ];
    sesv2 = [ mypy-boto3-sesv2 ];
    shield = [ mypy-boto3-shield ];
    signer = [ mypy-boto3-signer ];
    simspaceweaver = [ mypy-boto3-simspaceweaver ];
    sms = [ mypy-boto3-sms ];
    sms-voice = [ mypy-boto3-sms-voice ];
    snow-device-management = [ mypy-boto3-snow-device-management ];
    snowball = [ mypy-boto3-snowball ];
    sns = [ mypy-boto3-sns ];
    sqs = [ mypy-boto3-sqs ];
    ssm = [ mypy-boto3-ssm ];
    ssm-contacts = [ mypy-boto3-ssm-contacts ];
    ssm-incidents = [ mypy-boto3-ssm-incidents ];
    ssm-sap = [ mypy-boto3-ssm-sap ];
    sso = [ mypy-boto3-sso ];
    sso-admin = [ mypy-boto3-sso-admin ];
    sso-oidc = [ mypy-boto3-sso-oidc ];
    stepfunctions = [ mypy-boto3-stepfunctions ];
    storagegateway = [ mypy-boto3-storagegateway ];
    sts = [ mypy-boto3-sts ];
    support = [ mypy-boto3-support ];
    support-app = [ mypy-boto3-support-app ];
    swf = [ mypy-boto3-swf ];
    synthetics = [ mypy-boto3-synthetics ];
    textract = [ mypy-boto3-textract ];
    timestream-query = [ mypy-boto3-timestream-query ];
    timestream-write = [ mypy-boto3-timestream-write ];
    tnb = [ mypy-boto3-tnb ];
    transcribe = [ mypy-boto3-transcribe ];
    transfer = [ mypy-boto3-transfer ];
    translate = [ mypy-boto3-translate ];
    verifiedpermissions = [ mypy-boto3-verifiedpermissions ];
    voice-id = [ mypy-boto3-voice-id ];
    vpc-lattice = [ mypy-boto3-vpc-lattice ];
    waf = [ mypy-boto3-waf ];
    waf-regional = [ mypy-boto3-waf-regional ];
    wafv2 = [ mypy-boto3-wafv2 ];
    wellarchitected = [ mypy-boto3-wellarchitected ];
    wisdom = [ mypy-boto3-wisdom ];
    workdocs = [ mypy-boto3-workdocs ];
    worklink = [ mypy-boto3-worklink ];
    workmail = [ mypy-boto3-workmail ];
    workmailmessageflow = [ mypy-boto3-workmailmessageflow ];
    workspaces = [ mypy-boto3-workspaces ];
    workspaces-web = [ mypy-boto3-workspaces-web ];
    xray = [ mypy-boto3-xray ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "boto3-stubs" ];

  meta = with lib; {
    description = "Type annotations for boto3";
    homepage = "https://pypi.org/project/boto3-stubs/";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      mbalatsko
    ];
  };
}
