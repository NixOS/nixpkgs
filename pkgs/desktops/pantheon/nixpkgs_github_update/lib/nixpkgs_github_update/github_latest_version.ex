defmodule NixpkgsGitHubUpdate.GitHubLatestVersion do
  @user_agent 'httpc'

  def fetch({owner, repo}) do
    endpoint = releases_endpoint(owner, repo)

    oauth_token = String.to_charlist("#{System.get_env("OAUTH_TOKEN")}")

    headers = %{
      'User-Agent' => @user_agent,
      'Authorization' => 'token #{oauth_token}'
    }

    :httpc.request(:get, {endpoint, Map.to_list(headers)}, [], [])
    |> handle_response
  end

  def releases_endpoint(owner, repo) do
    'https://api.github.com/repos/#{owner}/#{repo}/releases/latest'
  end

  def handle_response({_, {{_httpv, status_code, _}, _headers, response}}) do
    {
      status_code |> check_for_error(),
      response |> Poison.Parser.parse!(%{})
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
