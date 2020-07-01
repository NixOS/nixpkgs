defmodule NixpkgsGitHubUpdate.GitHubLatestVersion do
  @user_agent 'httpc'

  def fetch({owner, repo}) do
    endpoint = releases_endpoint(owner, repo)
    headers = construct_headers()

    :httpc.request(:get, {endpoint, headers}, [], [])
    |> handle_response
  end

  def releases_endpoint(owner, repo) do
    'https://api.github.com/repos/#{owner}/#{repo}/releases/latest'
  end

  def construct_headers do
    headers = %{'User-Agent' => @user_agent}

    put_token(headers, get_token())
    |> Map.to_list
  end

  defp get_token do
    System.get_env("OAUTH_TOKEN")
  end

  defp put_token(headers, token) when token != nil do
    Map.put_new(headers, 'Authorization', 'token #{String.to_charlist(token)}')
  end

  defp put_token(headers, _), do: headers

  def handle_response({_, {{_httpv, status_code, _}, _headers, response}}) do
    {
      status_code |> check_for_error(),
      response |> Poison.Parser.parse!(%{})
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
