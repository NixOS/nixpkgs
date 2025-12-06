{
  ldflags = [

    "-s"
    "-w"
    "-X 'github.com/defenseunicorns/uds-cli/src/config.CLIVersion=v0.27.6'"
    "-X 'helm.sh/helm/v3/pkg/lint/rules.k8sVersionMajor=1'"
    "-X 'helm.sh/helm/v3/pkg/lint/rules.k8sVersionMinor=33'"
    "-X 'helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=1'"
    "-X 'helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=33'"
    "-X 'github.com/zarf-dev/zarf/src/config.ActionsCommandZarfPrefix=zarf'"
    "-X 'github.com/derailed/k9s/cmd.version=v0.40.5'"
    "-X 'github.com/google/go-containerregistry/cmd/crane/cmd.Version=v0.20.5'"
    "-X 'github.com/zarf-dev/zarf/src/cmd/tools.syftVersion=v1.26.1'"
    "-X 'github.com/zarf-dev/zarf/src/cmd/tools.archiverVersion=v3.5.1'"
    "-X 'github.com/zarf-dev/zarf/src/cmd/tools.helmVersion=v3.17.3'"
  ];
}
