defmodule NixpkgsGitHubUpdate.MixProject do
  use Mix.Project

  def project do
    [
      app: :nixpkgs_github_update,
      version: "0.1.0",
      elixir: "~> 1.9",
      escript: [main_module: NixpkgsGitHubUpdate.CLI],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0.1"}
    ]
  end
end
