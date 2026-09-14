{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  huaweicloudsdkcore,
}:

let
  buildHuaweiCloudSdkPackage =
    serviceName:
    buildPythonPackage (finalAttrs: {
      pname = "huaweicloudsdk${serviceName}";
      version = "3.1.213";
      pyproject = true;

      src = fetchFromGitHub {
        owner = "huaweicloud";
        repo = "huaweicloud-sdk-python-v3";
        tag = "v${finalAttrs.version}";
        hash = "sha256-Bir0DWGN0xpfUfC9KMwu/kfzM8jWaqC7S6BUat49zEY=";
      };

      sourceRoot = "${finalAttrs.src.name}/huaweicloud-sdk-${serviceName}";

      build-system = [ hatchling ];

      dependencies = [ huaweicloudsdkcore ];

      # All components are stored in a mono repo
      doCheck = false;

      pythonImportsCheck = [ "huaweicloudsdk${serviceName}" ];

      meta = {
        description = "Module of Huawei Cloud Python SDK (${serviceName})";
        homepage = "https://github.com/huaweicloud/huaweicloud-sdk-python-v3/";
        changelog = "https://github.com/huaweicloud/huaweicloud-sdk-python-v3/releases/tag/${finalAttrs.src.tag}";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ fab ];
      };
    });

in
{
  huaweicloudsdkaad = buildHuaweiCloudSdkPackage "aad";
  huaweicloudsdkagentarts = buildHuaweiCloudSdkPackage "agentarts";
  huaweicloudsdkagentidentity = buildHuaweiCloudSdkPackage "agentidentity";
  huaweicloudsdkaidatalake = buildHuaweiCloudSdkPackage "aidatalake";
  huaweicloudsdkantiddos = buildHuaweiCloudSdkPackage "antiddos";
  huaweicloudsdkaom = buildHuaweiCloudSdkPackage "aom";
  huaweicloudsdkaos = buildHuaweiCloudSdkPackage "aos";
  huaweicloudsdkapig = buildHuaweiCloudSdkPackage "apig";
  huaweicloudsdkapm = buildHuaweiCloudSdkPackage "apm";
  huaweicloudsdkas = buildHuaweiCloudSdkPackage "as";
  huaweicloudsdkasm = buildHuaweiCloudSdkPackage "asm";
  huaweicloudsdkastrozero = buildHuaweiCloudSdkPackage "astrozero";
  huaweicloudsdkbcc = buildHuaweiCloudSdkPackage "bcc";
  huaweicloudsdkbcs = buildHuaweiCloudSdkPackage "bcs";
  huaweicloudsdkbms = buildHuaweiCloudSdkPackage "bms";
  huaweicloudsdkbss = buildHuaweiCloudSdkPackage "bss";
  huaweicloudsdkbssintl = buildHuaweiCloudSdkPackage "bssintl";
  huaweicloudsdkcae = buildHuaweiCloudSdkPackage "cae";
  huaweicloudsdkcampusgo = buildHuaweiCloudSdkPackage "campusgo";
  huaweicloudsdkcbh = buildHuaweiCloudSdkPackage "cbh";
  huaweicloudsdkcbr = buildHuaweiCloudSdkPackage "cbr";
  huaweicloudsdkcbs = buildHuaweiCloudSdkPackage "cbs";
  huaweicloudsdkcc = buildHuaweiCloudSdkPackage "cc";
  huaweicloudsdkcce = buildHuaweiCloudSdkPackage "cce";
  huaweicloudsdkccm = buildHuaweiCloudSdkPackage "ccm";
  huaweicloudsdkcdm = buildHuaweiCloudSdkPackage "cdm";
  huaweicloudsdkcdn = buildHuaweiCloudSdkPackage "cdn";
  huaweicloudsdkces = buildHuaweiCloudSdkPackage "ces";
  huaweicloudsdkcfw = buildHuaweiCloudSdkPackage "cfw";
  huaweicloudsdkclassroom = buildHuaweiCloudSdkPackage "classroom";
  huaweicloudsdkclouddc = buildHuaweiCloudSdkPackage "clouddc";
  huaweicloudsdkcloudide = buildHuaweiCloudSdkPackage "cloudide";
  huaweicloudsdkcloudpond = buildHuaweiCloudSdkPackage "cloudpond";
  huaweicloudsdkcloudrtc = buildHuaweiCloudSdkPackage "cloudrtc";
  huaweicloudsdkcloudtable = buildHuaweiCloudSdkPackage "cloudtable";
  huaweicloudsdkcloudtest = buildHuaweiCloudSdkPackage "cloudtest";
  huaweicloudsdkcoc = buildHuaweiCloudSdkPackage "coc";
  huaweicloudsdkcodeartsartifact = buildHuaweiCloudSdkPackage "codeartsartifact";
  huaweicloudsdkcodeartsbuild = buildHuaweiCloudSdkPackage "codeartsbuild";
  huaweicloudsdkcodeartscheck = buildHuaweiCloudSdkPackage "codeartscheck";
  huaweicloudsdkcodeartsdeploy = buildHuaweiCloudSdkPackage "codeartsdeploy";
  huaweicloudsdkcodeartsgovernance = buildHuaweiCloudSdkPackage "codeartsgovernance";
  huaweicloudsdkcodeartside = buildHuaweiCloudSdkPackage "codeartside";
  huaweicloudsdkcodeartsinspector = buildHuaweiCloudSdkPackage "codeartsinspector";
  huaweicloudsdkcodeartspipeline = buildHuaweiCloudSdkPackage "codeartspipeline";
  huaweicloudsdkcodeartsrepo = buildHuaweiCloudSdkPackage "codeartsrepo";
  huaweicloudsdkcodecraft = buildHuaweiCloudSdkPackage "codecraft";
  huaweicloudsdkconfig = buildHuaweiCloudSdkPackage "config";
  huaweicloudsdkcpcs = buildHuaweiCloudSdkPackage "cpcs";
  huaweicloudsdkcph = buildHuaweiCloudSdkPackage "cph";
  huaweicloudsdkcpts = buildHuaweiCloudSdkPackage "cpts";
  huaweicloudsdkcse = buildHuaweiCloudSdkPackage "cse";
  huaweicloudsdkcsms = buildHuaweiCloudSdkPackage "csms";
  huaweicloudsdkcss = buildHuaweiCloudSdkPackage "css";
  huaweicloudsdkcts = buildHuaweiCloudSdkPackage "cts";
  huaweicloudsdkdas = buildHuaweiCloudSdkPackage "das";
  huaweicloudsdkdataartsfabric = buildHuaweiCloudSdkPackage "dataartsfabric";
  huaweicloudsdkdataartsfabricep = buildHuaweiCloudSdkPackage "dataartsfabricep";
  huaweicloudsdkdataartsstudio = buildHuaweiCloudSdkPackage "dataartsstudio";
  huaweicloudsdkdbss = buildHuaweiCloudSdkPackage "dbss";
  huaweicloudsdkdc = buildHuaweiCloudSdkPackage "dc";
  huaweicloudsdkdcc = buildHuaweiCloudSdkPackage "dcc";
  huaweicloudsdkdcos = buildHuaweiCloudSdkPackage "dcos";
  huaweicloudsdkdcs = buildHuaweiCloudSdkPackage "dcs";
  huaweicloudsdkddm = buildHuaweiCloudSdkPackage "ddm";
  huaweicloudsdkdds = buildHuaweiCloudSdkPackage "dds";
  huaweicloudsdkdeh = buildHuaweiCloudSdkPackage "deh";
  huaweicloudsdkdevstar = buildHuaweiCloudSdkPackage "devstar";
  huaweicloudsdkdgc = buildHuaweiCloudSdkPackage "dgc";
  huaweicloudsdkdis = buildHuaweiCloudSdkPackage "dis";
  huaweicloudsdkdlf = buildHuaweiCloudSdkPackage "dlf";
  huaweicloudsdkdli = buildHuaweiCloudSdkPackage "dli";
  huaweicloudsdkdns = buildHuaweiCloudSdkPackage "dns";
  huaweicloudsdkdris = buildHuaweiCloudSdkPackage "dris";
  huaweicloudsdkdrs = buildHuaweiCloudSdkPackage "drs";
  huaweicloudsdkdsc = buildHuaweiCloudSdkPackage "dsc";
  huaweicloudsdkdwr = buildHuaweiCloudSdkPackage "dwr";
  huaweicloudsdkdws = buildHuaweiCloudSdkPackage "dws";
  huaweicloudsdkec = buildHuaweiCloudSdkPackage "ec";
  huaweicloudsdkecs = buildHuaweiCloudSdkPackage "ecs";
  huaweicloudsdkedgesec = buildHuaweiCloudSdkPackage "edgesec";
  huaweicloudsdkeg = buildHuaweiCloudSdkPackage "eg";
  huaweicloudsdkeihealth = buildHuaweiCloudSdkPackage "eihealth";
  huaweicloudsdkeip = buildHuaweiCloudSdkPackage "eip";
  huaweicloudsdkelb = buildHuaweiCloudSdkPackage "elb";
  huaweicloudsdkeps = buildHuaweiCloudSdkPackage "eps";
  huaweicloudsdker = buildHuaweiCloudSdkPackage "er";
  huaweicloudsdkesw = buildHuaweiCloudSdkPackage "esw";
  huaweicloudsdkevs = buildHuaweiCloudSdkPackage "evs";
  huaweicloudsdkfrs = buildHuaweiCloudSdkPackage "frs";
  huaweicloudsdkfunctiongraph = buildHuaweiCloudSdkPackage "functiongraph";
  huaweicloudsdkga = buildHuaweiCloudSdkPackage "ga";
  huaweicloudsdkgaussdb = buildHuaweiCloudSdkPackage "gaussdb";
  huaweicloudsdkgaussdbfornosql = buildHuaweiCloudSdkPackage "gaussdbfornosql";
  huaweicloudsdkgaussdbforopengauss = buildHuaweiCloudSdkPackage "gaussdbforopengauss";
  huaweicloudsdkgeip = buildHuaweiCloudSdkPackage "geip";
  huaweicloudsdkges = buildHuaweiCloudSdkPackage "ges";
  huaweicloudsdkgsl = buildHuaweiCloudSdkPackage "gsl";
  huaweicloudsdkhilens = buildHuaweiCloudSdkPackage "hilens";
  huaweicloudsdkhss = buildHuaweiCloudSdkPackage "hss";
  huaweicloudsdkiam = buildHuaweiCloudSdkPackage "iam";
  huaweicloudsdkiamaccessanalyzer = buildHuaweiCloudSdkPackage "iamaccessanalyzer";
  huaweicloudsdkidentitycenter = buildHuaweiCloudSdkPackage "identitycenter";
  huaweicloudsdkidentitycenteroidc = buildHuaweiCloudSdkPackage "identitycenteroidc";
  huaweicloudsdkidentitycenterportalapi = buildHuaweiCloudSdkPackage "identitycenterportalapi";
  huaweicloudsdkidentitycenterscim = buildHuaweiCloudSdkPackage "identitycenterscim";
  huaweicloudsdkidentitycenterstore = buildHuaweiCloudSdkPackage "identitycenterstore";
  huaweicloudsdkidme = buildHuaweiCloudSdkPackage "idme";
  huaweicloudsdkidmeclassicapi = buildHuaweiCloudSdkPackage "idmeclassicapi";
  huaweicloudsdkiec = buildHuaweiCloudSdkPackage "iec";
  huaweicloudsdkief = buildHuaweiCloudSdkPackage "ief";
  huaweicloudsdkimage = buildHuaweiCloudSdkPackage "image";
  huaweicloudsdkimagesearch = buildHuaweiCloudSdkPackage "imagesearch";
  huaweicloudsdkims = buildHuaweiCloudSdkPackage "ims";
  huaweicloudsdkiotanalytics = buildHuaweiCloudSdkPackage "iotanalytics";
  huaweicloudsdkiotda = buildHuaweiCloudSdkPackage "iotda";
  huaweicloudsdkiotdm = buildHuaweiCloudSdkPackage "iotdm";
  huaweicloudsdkiotedge = buildHuaweiCloudSdkPackage "iotedge";
  huaweicloudsdkivs = buildHuaweiCloudSdkPackage "ivs";
  huaweicloudsdkkafka = buildHuaweiCloudSdkPackage "kafka";
  huaweicloudsdkkms = buildHuaweiCloudSdkPackage "kms";
  huaweicloudsdkkoomessage = buildHuaweiCloudSdkPackage "koomessage";
  huaweicloudsdkkps = buildHuaweiCloudSdkPackage "kps";
  huaweicloudsdkkvs = buildHuaweiCloudSdkPackage "kvs";
  huaweicloudsdklakeformation = buildHuaweiCloudSdkPackage "lakeformation";
  huaweicloudsdklive = buildHuaweiCloudSdkPackage "live";
  huaweicloudsdklts = buildHuaweiCloudSdkPackage "lts";
  huaweicloudsdkmapds = buildHuaweiCloudSdkPackage "mapds";
  huaweicloudsdkmas = buildHuaweiCloudSdkPackage "mas";
  huaweicloudsdkmastudio = buildHuaweiCloudSdkPackage "mastudio";
  huaweicloudsdkmeeting = buildHuaweiCloudSdkPackage "meeting";
  huaweicloudsdkmetastudio = buildHuaweiCloudSdkPackage "metastudio";
  huaweicloudsdkmodelarts = buildHuaweiCloudSdkPackage "modelarts";
  huaweicloudsdkmoderation = buildHuaweiCloudSdkPackage "moderation";
  huaweicloudsdkmpc = buildHuaweiCloudSdkPackage "mpc";
  huaweicloudsdkmrs = buildHuaweiCloudSdkPackage "mrs";
  huaweicloudsdkmsgsms = buildHuaweiCloudSdkPackage "msgsms";
  huaweicloudsdkmssi = buildHuaweiCloudSdkPackage "mssi";
  huaweicloudsdknat = buildHuaweiCloudSdkPackage "nat";
  huaweicloudsdknlp = buildHuaweiCloudSdkPackage "nlp";
  huaweicloudsdkobs = buildHuaweiCloudSdkPackage "obs";
  huaweicloudsdkocr = buildHuaweiCloudSdkPackage "ocr";
  huaweicloudsdkoctopus = buildHuaweiCloudSdkPackage "octopus";
  huaweicloudsdkoms = buildHuaweiCloudSdkPackage "oms";
  huaweicloudsdkoptverse = buildHuaweiCloudSdkPackage "optverse";
  huaweicloudsdkorganizations = buildHuaweiCloudSdkPackage "organizations";
  huaweicloudsdkorgid = buildHuaweiCloudSdkPackage "orgid";
  huaweicloudsdkoroas = buildHuaweiCloudSdkPackage "oroas";
  huaweicloudsdkosm = buildHuaweiCloudSdkPackage "osm";
  huaweicloudsdkpangulargemodels = buildHuaweiCloudSdkPackage "pangulargemodels";
  huaweicloudsdkprojectman = buildHuaweiCloudSdkPackage "projectman";
  huaweicloudsdkrabbitmq = buildHuaweiCloudSdkPackage "rabbitmq";
  huaweicloudsdkram = buildHuaweiCloudSdkPackage "ram";
  huaweicloudsdkrc = buildHuaweiCloudSdkPackage "rc";
  huaweicloudsdkrds = buildHuaweiCloudSdkPackage "rds";
  huaweicloudsdkres = buildHuaweiCloudSdkPackage "res";
  huaweicloudsdkrfs = buildHuaweiCloudSdkPackage "rfs";
  huaweicloudsdkrgc = buildHuaweiCloudSdkPackage "rgc";
  huaweicloudsdkrms = buildHuaweiCloudSdkPackage "rms";
  huaweicloudsdkrocketmq = buildHuaweiCloudSdkPackage "rocketmq";
  huaweicloudsdkroma = buildHuaweiCloudSdkPackage "roma";
  huaweicloudsdksa = buildHuaweiCloudSdkPackage "sa";
  huaweicloudsdkscm = buildHuaweiCloudSdkPackage "scm";
  huaweicloudsdksdrs = buildHuaweiCloudSdkPackage "sdrs";
  huaweicloudsdksecmaster = buildHuaweiCloudSdkPackage "secmaster";
  huaweicloudsdkservicestage = buildHuaweiCloudSdkPackage "servicestage";
  huaweicloudsdksfsturbo = buildHuaweiCloudSdkPackage "sfsturbo";
  huaweicloudsdksis = buildHuaweiCloudSdkPackage "sis";
  huaweicloudsdksmn = buildHuaweiCloudSdkPackage "smn";
  huaweicloudsdksmnglobal = buildHuaweiCloudSdkPackage "smnglobal";
  huaweicloudsdksms = buildHuaweiCloudSdkPackage "sms";
  huaweicloudsdksmsapi = buildHuaweiCloudSdkPackage "smsapi";
  huaweicloudsdksts = buildHuaweiCloudSdkPackage "sts";
  huaweicloudsdkswr = buildHuaweiCloudSdkPackage "swr";
  huaweicloudsdktics = buildHuaweiCloudSdkPackage "tics";
  huaweicloudsdktms = buildHuaweiCloudSdkPackage "tms";
  huaweicloudsdkucs = buildHuaweiCloudSdkPackage "ucs";
  huaweicloudsdkugo = buildHuaweiCloudSdkPackage "ugo";
  huaweicloudsdkvas = buildHuaweiCloudSdkPackage "vas";
  huaweicloudsdkvcm = buildHuaweiCloudSdkPackage "vcm";
  huaweicloudsdkversatile = buildHuaweiCloudSdkPackage "versatile";
  huaweicloudsdkvod = buildHuaweiCloudSdkPackage "vod";
  huaweicloudsdkvpc = buildHuaweiCloudSdkPackage "vpc";
  huaweicloudsdkvpcep = buildHuaweiCloudSdkPackage "vpcep";
  huaweicloudsdkvpn = buildHuaweiCloudSdkPackage "vpn";
  huaweicloudsdkwaf = buildHuaweiCloudSdkPackage "waf";
  huaweicloudsdkworkspace = buildHuaweiCloudSdkPackage "workspace";
  huaweicloudsdkworkspaceapp = buildHuaweiCloudSdkPackage "workspaceapp";
}
